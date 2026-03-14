const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres',
  logging: false,
});

const connectDB = async () => {
  try {
    await sequelize.authenticate();
    console.log('? Database Connected Successfully.');
  } catch (error) {
    console.error('? Database Connection Failed:', error.message);
    console.log('?? Note: Make sure PostgreSQL is installed and running!');
  }
};

module.exports = { sequelize, connectDB };
