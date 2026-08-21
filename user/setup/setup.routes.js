const express = require('express');
const { getSetup, updateOrder,advanceParticipant } = require('./setup.controller');
const router = express.Router();

// No verifyToken here – it's applied in server.js
router.get('/setup', getSetup);
router.put('/participants/order', updateOrder);
router.post('/participants/advance', advanceParticipant);

module.exports = router;