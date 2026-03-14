const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { connectDB, sequelize } = require('./config/db');

const app = express();

// 1. ROBUST CORS SETUP
// We use a single middleware to handle both standard requests and preflight OPTIONS
app.use(cors({
  origin: '*', 
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
  preflightContinue: false,
  optionsSuccessStatus: 204
}));

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

// 4. PORT BINDING (Render + Local 5000 Support)
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 OneHub Server is live on port ${PORT}`);
});

module.exports = app;