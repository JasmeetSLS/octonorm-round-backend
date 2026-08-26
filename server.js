require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const { connectDB } = require('./config/db');
const { verifyToken } = require('./middleware/auth');

// Import routes
const authRoutes = require('./auth/auth.routes');
const setupRoutes = require('./user/setup/setup.routes');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Connect DB
connectDB();

// Routes
// Routes
app.use('/api', authRoutes); // POST /api/login

// Public test route
app.get('/api', (req, res) => {
    res.json({
        status: 'OK',
        message: 'Server is running',
        timestamp: new Date().toISOString()
    });
});

// Protected setup routes
app.use('/api', verifyToken, setupRoutes);

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});