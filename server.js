const express = require('express');
const cors = require('cors');
const multer = require('multer');
const XLSX = require('xlsx');
const fs = require('fs');
const path = require('path');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Database connection
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'root',
    database: process.env.DB_NAME || 'octonorm_round',
    waitForConnections: true,
    connectionLimit: 10
}).promise();

// Middleware
app.use(cors());
app.use(express.json());

// File upload setup
const storage = multer.diskStorage({
    destination: './uploads/',
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({
    storage,
    fileFilter: (req, file, cb) => {
        const allowed = ['.csv', '.xlsx', '.xls'];
        const ext = path.extname(file.originalname).toLowerCase();
        cb(null, allowed.includes(ext));
    },
    limits: { fileSize: 10 * 1024 * 1024 } // 10MB
});

// Create uploads folder if not exists
if (!fs.existsSync('./uploads')) {
    fs.mkdirSync('./uploads');
}

// ==================== SINGLE POST API ====================

// POST /api/setup - Save everything at once
app.post('/api/setup', upload.single('file'), async (req, res) => {
    const connection = await pool.getConnection();
    
    try {
        await connection.beginTransaction();
        
        const data = req.body;
        const file = req.file;
        
        // Parse JSON data from form-data
        const setupData = typeof data.setup === 'string' ? JSON.parse(data.setup) : data.setup || data;
        
        // 1. Save Setup Configuration
        const [current] = await connection.query(
            'SELECT id FROM setup_config ORDER BY id DESC LIMIT 1'
        );
        
        let setupId;
        const configData = {
            preparation_enabled: setupData.preparationEnabled ? 1 : 0,
            preparation_booths: setupData.preparationBooths || 5,
            preparation_time: setupData.preparationTimePerCase || 5,
            auto_close_prep: setupData.autoClosePrep ? 1 : 0,
            evaluation_rounds: setupData.evaluationRounds || 2,
            evaluator_count: setupData.numberOfEvaluators || 5,
            mapping_enabled: setupData.evaluatorToParticipantMapping ? 1 : 0,
            evaluation_time: setupData.timePerEvaluationRound || 10,
            reminder_enabled: setupData.reminderEnabled ? 1 : 0,
            reminder_count: setupData.reminderCount || 3,
            auto_submit: setupData.autoSubmit ? 1 : 0
        };
        
        if (current.length === 0) {
            const [result] = await connection.query(
                'INSERT INTO setup_config SET ?',
                [configData]
            );
            setupId = result.insertId;
        } else {
            setupId = current[0].id;
            await connection.query(
                'UPDATE setup_config SET ? WHERE id = ?',
                [configData, setupId]
            );
        }
        
        // 2. Process Excel/CSV File (Participants with Roles)
        let roles = [];
        let participants = [];
        let mappings = [];
        let trainers = [];
        
        if (file) {
            // Read Excel/CSV file
            const workbook = XLSX.readFile(file.path);
            const sheet = workbook.Sheets[workbook.SheetNames[0]];
            const fileData = XLSX.utils.sheet_to_json(sheet);
            
            // Clear existing roles, participants, mappings
            await connection.query('DELETE FROM trainer_mappings WHERE setup_id = ?', [setupId]);
            await connection.query('DELETE FROM participants');
            await connection.query('DELETE FROM roles');
            
            // Process each row from file
            for (const row of fileData) {
                const participantName = row.participant || row.Participant || row.name || row.Name || '';
                const roleName = row.role || row.Role || row.designation || row.Designation || '';
                const trainerName = row.trainer || row.Trainer || row.evaluator || row.Evaluator || '';
                const email = row.email || row.Email || '';
                
                if (participantName) {
                    // Find or create role
                    let roleId = null;
                    if (roleName) {
                        let [role] = await connection.query(
                            'SELECT id FROM roles WHERE name = ?',
                            [roleName]
                        );
                        
                        if (role.length === 0) {
                            const [result] = await connection.query(
                                'INSERT INTO roles (name, count) VALUES (?, ?)',
                                [roleName, 0]
                            );
                            roleId = result.insertId;
                        } else {
                            roleId = role[0].id;
                        }
                    }
                    
                    // Create participant
                    const [result] = await connection.query(
                        'INSERT INTO participants (name, email, role_id) VALUES (?, ?, ?)',
                        [participantName, email || null, roleId]
                    );
                    const participantId = result.insertId;
                    participants.push({ id: participantId, name: participantName, role: roleName });
                    
                    // Handle trainer mapping
                    if (trainerName) {
                        let [trainer] = await connection.query(
                            'SELECT id FROM trainers WHERE name = ?',
                            [trainerName]
                        );
                        
                        let trainerId;
                        if (trainer.length === 0) {
                            const [result] = await connection.query(
                                'INSERT INTO trainers (name) VALUES (?)',
                                [trainerName]
                            );
                            trainerId = result.insertId;
                            trainers.push({ id: trainerId, name: trainerName });
                        } else {
                            trainerId = trainer[0].id;
                        }
                        
                        // Create mapping
                        await connection.query(
                            `INSERT INTO trainer_mappings (setup_id, trainer_id, participant_id) 
                             VALUES (?, ?, ?)`,
                            [setupId, trainerId, participantId]
                        );
                        mappings.push({ trainer_id: trainerId, participant_id: participantId });
                    }
                }
            }
            
            // Update role counts
            const [allRoles] = await connection.query('SELECT id, name FROM roles');
            for (const role of allRoles) {
                const [count] = await connection.query(
                    'SELECT COUNT(*) as total FROM participants WHERE role_id = ?',
                    [role.id]
                );
                await connection.query(
                    'UPDATE roles SET count = ? WHERE id = ?',
                    [count[0].total, role.id]
                );
            }
            
            // Delete temp file
            fs.unlinkSync(file.path);
        } else {
            // If no file uploaded, check if roles are provided in the request
            if (setupData.roleHolderCategories && setupData.roleHolderCategories.length > 0) {
                await connection.query('DELETE FROM roles');
                for (const role of setupData.roleHolderCategories) {
                    await connection.query(
                        'INSERT INTO roles (name, count) VALUES (?, ?)',
                        [role.name, role.count || 0]
                    );
                }
            }
        }
        
        await connection.commit();
        connection.release();
        
        // Get complete saved data
        const [setup] = await connection.query(
            'SELECT * FROM setup_config WHERE id = ?',
            [setupId]
        );
        const [allRoles] = await connection.query('SELECT * FROM roles ORDER BY id');
        const [allParticipants] = await connection.query(`
            SELECT p.*, r.name as role_name 
            FROM participants p
            LEFT JOIN roles r ON r.id = p.role_id
            ORDER BY p.id
        `);
        const [allTrainers] = await connection.query('SELECT * FROM trainers ORDER BY id');
        const [allMappings] = await connection.query(`
            SELECT tm.*, t.name as trainer_name, p.name as participant_name 
            FROM trainer_mappings tm
            LEFT JOIN trainers t ON t.id = tm.trainer_id
            LEFT JOIN participants p ON p.id = tm.participant_id
            WHERE tm.setup_id = ?
        `, [setupId]);
        
        res.json({
            success: true,
            message: 'Setup saved successfully',
            data: {
                setup: setup[0],
                roles: allRoles,
                participants: allParticipants,
                trainers: allTrainers,
                mappings: allMappings,
                fileProcessed: file ? true : false,
                totalParticipants: allParticipants.length,
                totalMappings: allMappings.length
            }
        });
        
    } catch (error) {
        await connection.rollback();
        connection.release();
        console.error('Error saving setup:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to save setup',
            error: error.message
        });
    }
});

// GET /api/setup - Get all setup data
app.get('/api/setup', async (req, res) => {
    try {
        const [setup] = await pool.query(
            'SELECT * FROM setup_config ORDER BY id DESC LIMIT 1'
        );
        
        const [roles] = await pool.query('SELECT * FROM roles ORDER BY id');
        const [participants] = await pool.query(`
            SELECT p.*, r.name as role_name 
            FROM participants p
            LEFT JOIN roles r ON r.id = p.role_id
            ORDER BY p.id
        `);
        const [trainers] = await pool.query('SELECT * FROM trainers ORDER BY id');
        
        let mappings = [];
        if (setup.length > 0) {
            const [result] = await pool.query(`
                SELECT tm.*, t.name as trainer_name, p.name as participant_name 
                FROM trainer_mappings tm
                LEFT JOIN trainers t ON t.id = tm.trainer_id
                LEFT JOIN participants p ON p.id = tm.participant_id
                WHERE tm.setup_id = ?
            `, [setup[0].id]);
            mappings = result;
        }
        
        res.json({
            success: true,
            data: {
                setup: setup[0] || {},
                roles,
                participants,
                trainers,
                mappings,
                totalParticipants: participants.length,
                totalMappings: mappings.length
            }
        });
    } catch (error) {
        console.error('Error fetching setup:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch setup',
            error: error.message
        });
    }
});

// GET /api/export-template - Download template
app.get('/api/export-template', (req, res) => {
    const template = [
        { participant: 'John Doe', role: 'TC', trainer: 'Dr. Smith', email: 'john@example.com' },
        { participant: 'Jane Smith', role: 'DFM', trainer: 'Dr. Jones', email: 'jane@example.com' },
        { participant: 'Bob Wilson', role: 'SHE', trainer: 'Dr. Williams', email: 'bob@example.com' }
    ];
    
    const wb = XLSX.utils.book_new();
    const ws = XLSX.utils.json_to_sheet(template);
    XLSX.utils.book_append_sheet(wb, ws, 'Participants');
    
    const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
    
    res.setHeader('Content-Disposition', 'attachment; filename=participant_template.xlsx');
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.send(buffer);
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📁 API: http://localhost:${PORT}/api`);
    console.log(`📤 POST /api/setup - Upload Excel with participants`);
    console.log(`📥 GET /api/setup - Get all setup data`);
    console.log(`📄 GET /api/export-template - Download template`);
});