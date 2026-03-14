const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { connectDB, sequelize } = require('./config/db');

const app = express();

// 1. UPDATED CORS SETUP
// We changed '*' to '/(.*)' to comply with Express 5 wildcard rules
app.use(cors({
  origin: '*', 
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

// Explicitly handle OPTIONS requests using the new regex pattern
app.options('/(.*)', cors());

app.use(express.json());

// 2. DATABASE CONNECTION
connectDB();

sequelize.sync({ alter: true })
  .then(() => console.log("📦 Database Tables Synced"))
  .catch(err => console.log("⚠️ Database Sync Skipped:", err.message));

// 3. ROUTES
app.use('/api/auth', require('./routes/auth'));
app.use('/api/products', require('./routes/products'));
app.use('/api/transactions', require('./routes/transactions'));
app.use('/api/wallet', require('./routes/wallet'));
app.use('/api/upload', require('./routes/upload'));
app.use('/api/paystack', require('./routes/paystack'));
app.use('/api/messages', require('./routes/messages'));
app.use('/uploads', express.static('uploads'));

app.get('/', (req, res) => res.send('OneHub API is operational.'));

// 4. RENDER/PRODUCTION COMPATIBILITY
// Render requires the app to listen on a port provided by the environment
const PORT = process.env.PORT || 10000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server is running on port ${PORT}`);
});

module.exports = app;