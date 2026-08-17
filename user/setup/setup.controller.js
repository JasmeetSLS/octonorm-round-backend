const { pool } = require('../../config/db');

// GET /api/setup
exports.getSetup = async (req, res) => {
  try {
    const userId = req.user.id;
    const [user] = await pool.query('SELECT role_id, trainer_id FROM users WHERE id = ?', [userId]);
    if (!user.length) {
      return res.status(401).json({ success: false, message: 'User not found' });
    }
    const roleId = user[0].role_id;
    const trainerId = user[0].trainer_id;

    // Permissions
    const [perms] = await pool.query(
      'SELECT stage_key, can_view, can_move, can_edit_trainer FROM role_permissions WHERE role_id = ?',
      [roleId]
    );
    const permissions = {};
    perms.forEach(p => {
      permissions[p.stage_key] = {
        view: p.can_view === 1,
        move: p.can_move === 1,
        editTrainer: p.can_edit_trainer === 1,
      };
    });

    let setupId = req.query.setup_id;
    if (!setupId) {
      const [rows] = await pool.query('SELECT id FROM setup ORDER BY id DESC LIMIT 1');
      if (rows.length === 0) {
        return res.json({
          success: true,
          data: { setup: null, trainers: [], rooms: [], participants: [], rounds: [], permissions },
        });
      }
      setupId = rows[0].id;
    }

    const [setupRows] = await pool.query('SELECT * FROM setup WHERE id = ?', [setupId]);
    const [trainers] = await pool.query('SELECT * FROM trainers ORDER BY id');
    const [rooms] = await pool.query('SELECT * FROM rooms WHERE setup_id = ? ORDER BY id', [setupId]);

    let participantsQuery = `
      SELECT 
        p.*,
        t.name AS trainer_name,
        r.name AS room_name,
        r.vehicle_name
      FROM participants p
      LEFT JOIN trainers t ON p.trainer_id = t.id
      LEFT JOIN rooms r ON p.room_id = r.id
      WHERE p.setup_id = ?
    `;
    const queryParams = [setupId];
    if (trainerId) {
      participantsQuery += ' AND p.trainer_id = ?';
      queryParams.push(trainerId);
    }
    participantsQuery += ' ORDER BY p.room_id, p.position';

    const [participants] = await pool.query(participantsQuery, queryParams);
    const [rounds] = await pool.query('SELECT * FROM rounds WHERE setup_id = ? ORDER BY id', [setupId]);

    res.json({
      success: true,
      data: {
        setup: setupRows[0] || null,
        trainers,
        rooms,
        participants,
        rounds,
        permissions,
      },
    });
  } catch (error) {
    console.error('Error fetching setup:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// PUT /api/participants/order
exports.updateOrder = async (req, res) => {
  const { setup_id, rooms } = req.body;
  if (!setup_id || !rooms) {
    return res.status(400).json({ success: false, message: 'Missing setup_id or rooms' });
  }

  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

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
};