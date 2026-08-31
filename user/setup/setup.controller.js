const { pool } = require('../../config/db');


exports.getSetup = async (req, res) => {
  try {
    const userId = req.user.id;
    const [user] = await pool.query('SELECT role_id FROM users WHERE id = ?', [userId]);
    if (!user.length) {
      return res.status(401).json({ success: false, message: 'User not found' });
    }
    const roleId = user[0].role_id;

    // --- Determine setupId first ---
    let setupId = req.query.setup_id;
    if (!setupId) {
      const [rows] = await pool.query('SELECT id FROM setup ORDER BY id DESC LIMIT 1');
      if (rows.length === 0) {
        // No setup exists -> return empty with default permissions
        return res.json({
          success: true,
          data: {
            setup: null,
            trainers: [],
            rooms: [],
            participants: [],
            rounds: [],
            timeSlots: [],
            permissions: { view: false, edit: false, delete: false }
          }
        });
      }
      setupId = rows[0].id;
    }

    // --- Fetch setup permissions (instead of stage permissions) ---
    const [perms] = await pool.query(
      `SELECT can_view, can_edit, can_delete 
       FROM role_permissions 
       WHERE role_id = ? AND (setup_id = ? OR setup_id IS NULL)
       ORDER BY CASE WHEN setup_id IS NOT NULL THEN 1 ELSE 2 END
       LIMIT 1`,
      [roleId, setupId]
    );

    let permissions = { view: false, edit: false, delete: false };
    if (perms.length) {
      permissions = {
        view: perms[0].can_view === 1,
        edit: perms[0].can_edit === 1,
        delete: perms[0].can_delete === 1,
      };
    }

    // --- Enforce view permission ---
    if (!permissions.view) {
      return res.status(403).json({ success: false, message: 'Access denied' });
    }

    // --- Rest of the code (unchanged) ---
    const [setupRows] = await pool.query('SELECT * FROM setup WHERE id = ?', [setupId]);
    const [trainers] = await pool.query('SELECT * FROM trainers ORDER BY id');
    const [rooms] = await pool.query(
      'SELECT id, name, vehicle_name, trainer_id FROM rooms WHERE setup_id = ? ORDER BY id',
      [setupId]
    );

    let participantsQuery = `
      SELECT 
        p.*,
        t.name AS trainer_name,
        r.name AS room_name,
        r.vehicle_name,
        ts.time AS time_slot_time,
        p.current_stage
      FROM participants p
      LEFT JOIN trainers t ON p.trainer_id = t.id
      LEFT JOIN rooms r ON p.room_id = r.id
      LEFT JOIN time_slots ts ON p.time_slot_id = ts.id
      WHERE p.setup_id = ?
      ORDER BY p.room_id, p.position
    `;
    const [participants] = await pool.query(participantsQuery, [setupId]);

    if (participants.length) {
      const participantIds = participants.map(p => p.id);
      const [roundsData] = await pool.query(
        `SELECT participant_id, round_id FROM participant_rounds 
         WHERE participant_id IN (?)`,
        [participantIds]
      );
      const roundsMap = {};
      roundsData.forEach(pr => {
        if (!roundsMap[pr.participant_id]) roundsMap[pr.participant_id] = [];
        roundsMap[pr.participant_id].push(pr.round_id);
      });
      participants.forEach(p => {
        p.current_stage = p.current_stage || 'main';
        p.assigned_rounds = roundsMap[p.id] || [];
      });
    }

    const [rounds] = await pool.query('SELECT * FROM rounds WHERE setup_id = ? ORDER BY id', [setupId]);
    const [timeSlots] = await pool.query('SELECT * FROM time_slots ORDER BY id');

    res.json({
      success: true,
      data: {
        setup: setupRows[0] || null,
        trainers,
        rooms,
        participants,
        rounds,
        timeSlots,
        permissions,   // now { view, edit, delete }
      },
    });
  } catch (error) {
    console.error('Error fetching setup:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// ── updateOrder (unchanged) ──
exports.updateOrder = async (req, res) => {
  const { setup_id, rooms } = req.body;

  if (!setup_id || !rooms) {
    return res.status(400).json({ success: false, message: 'Missing setup_id or rooms' });
  }

  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    const [timeSlots] = await connection.query('SELECT id FROM time_slots ORDER BY id');

    for (const [roomId, participantIds] of Object.entries(rooms)) {
      const [roomRows] = await connection.query(
        'SELECT trainer_id FROM rooms WHERE id = ?',
        [roomId]
      );
      const trainerId = roomRows.length ? roomRows[0].trainer_id : null;

      for (let i = 0; i < participantIds.length; i++) {
        const timeSlotId = (i < timeSlots.length) ? timeSlots[i].id : null;

        await connection.query(
          `UPDATE participants 
           SET room_id = ?, position = ?, trainer_id = ?, time_slot_id = ? 
           WHERE id = ? AND setup_id = ?`,
          [roomId, i, trainerId, timeSlotId, participantIds[i], setup_id]
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
};

// ── NEW: Advance participant to next stage ──
exports.advanceParticipant = async (req, res) => {
  const { participant_id, new_stage } = req.body;
  try {
    await pool.query(
      'UPDATE participants SET current_stage = ? WHERE id = ?',
      [new_stage, participant_id]
    );
    res.json({ success: true });
  } catch (error) {
    console.error('Error advancing participant:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};