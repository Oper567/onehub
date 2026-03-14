const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { connectDB, sequelize } = require('./config/db');

const app = express();

// 1. ADVANCED CORS SETUP
// This handles the "Preflight" OPTIONS request that is currently blocking your login
app.use(cors({
  origin: '*', // Allows your Netlify frontend to connect
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

// Explicitly handle OPTIONS requests
app.options('*', cors());

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

// 4. VERCEL COMPATIBILITY
// Vercel handles the port automatically; we only use app.listen for local testing
if (process.env.NODE_ENV !== 'production') {
  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => console.log(`🚀 Server on port ${PORT}`));
}

module.exports = app;