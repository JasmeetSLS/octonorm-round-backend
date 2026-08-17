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
app.use('/uploads', express.static('uploads'));
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

// GET /api/setup - Get all setup data
app.get('/api/setup', async (req, res) => {
    try {
        let setupId = req.query.setup_id;
        if (!setupId) {
            const [rows] = await pool.query('SELECT id FROM setup ORDER BY id DESC LIMIT 1');
            if (rows.length === 0) {
                return res.json({ success: true, data: { setup: null, trainers: [], rooms: [], participants: [], rounds: [] } });
            }
            setupId = rows[0].id;
        }

        const [setupRows] = await pool.query('SELECT * FROM setup WHERE id = ?', [setupId]);
        const [trainers] = await pool.query('SELECT * FROM trainers ORDER BY id');
        const [rooms] = await pool.query('SELECT * FROM rooms WHERE setup_id = ? ORDER BY id', [setupId]);

        // Participants sorted by room_id, then position
        const [participants] = await pool.query(`
            SELECT 
                p.*,
                t.name AS trainer_name,
                r.name AS room_name,
                r.vehicle_name
            FROM participants p
            LEFT JOIN trainers t ON p.trainer_id = t.id
            LEFT JOIN rooms r ON p.room_id = r.id
            WHERE p.setup_id = ?
            ORDER BY p.room_id, p.position
        `, [setupId]);

        const [rounds] = await pool.query('SELECT * FROM rounds WHERE setup_id = ? ORDER BY id', [setupId]);

        res.json({
            success: true,
            data: { setup: setupRows[0] || null, trainers, rooms, participants, rounds }
        });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});

// PUT /api/participants/order – update room and position for multiple participants
app.put('/api/participants/order', async (req, res) => {
    const { setup_id, rooms } = req.body;
    if (!setup_id || !rooms) {
        return res.status(400).json({ success: false, message: 'Missing setup_id or rooms' });
    }

    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        // rooms: { roomId: [participantId1, participantId2, ...] }
        for (const [roomId, participantIds] of Object.entries(rooms)) {
            for (let i = 0; i < participantIds.length; i++) {
                await connection.query(
                    'UPDATE participants SET room_id = ?, position = ? WHERE id = ? AND setup_id = ?',
                    [roomId, i, participantIds[i], setup_id]
                );
            }
        }

        await connection.commit();
        connection.release();
        res.json({ success: true, message: 'Order updated successfully' });
    } catch (error) {
        await connection.rollback();
        connection.release();
        console.error('Error updating order:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📁 API: http://localhost:${PORT}/api`);
    console.log(`📤 POST /api/setup - Upload Excel with participants`);
    console.log(`📥 GET /api/setup - Get all setup data`);
    console.log(`📄 GET /api/export-template - Download template`);
});