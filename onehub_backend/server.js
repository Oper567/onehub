const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { connectDB, sequelize } = require('./config/db');

const app = express();
app.use(cors());
app.use(express.json());

connectDB();

sequelize.sync({ alter: true }).then(() => {
  console.log("?? Database Tables Synced");
}).catch(err => console.log("Database Sync Skipped (No connection yet)"));

app.use('/api/auth', require('./routes/auth'));
app.use('/api/products', require('./routes/products'));
app.use('/api/transactions', require('./routes/transactions'));
app.use('/api/wallet', require('./routes/wallet'));
app.use('/api/upload', require('./routes/upload'));
app.use('/api/paystack', require('./routes/paystack'));
app.use('/api/messages', require('./routes/messages'));
app.use('/uploads', express.static('uploads'));

app.get('/', (req, res) => res.send('OneHub API is operational.'));
const cors = require('cors');
app.use(cors()); // This allows your Flutter Web app to talk to your Vercel API!

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`?? Server on port ${PORT}`));

module.exports = app;




