const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

const Wallet = sequelize.define('Wallet', {
  id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4, primaryKey: true },
  userId: { type: DataTypes.UUID, allowNull: false },
  available_balance: { type: DataTypes.DOUBLE, defaultValue: 1000.0 }, // Giving users some fake starting money
  escrow_balance: { type: DataTypes.DOUBLE, defaultValue: 0.0 }
});

module.exports = Wallet;
