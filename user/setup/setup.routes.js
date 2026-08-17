const express = require('express');
const { getSetup, updateOrder } = require('./setup.controller');
const router = express.Router();

// No verifyToken here – it's applied in server.js
router.get('/setup', getSetup);
router.put('/participants/order', updateOrder);

module.exports = router;