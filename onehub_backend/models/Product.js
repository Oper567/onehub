const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

const Product = sequelize.define('Product', {
  id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4, primaryKey: true },
  name: { type: DataTypes.STRING, allowNull: false },
  price: { type: DataTypes.DOUBLE, allowNull: false },
  category: { type: DataTypes.STRING, defaultValue: 'Hardware' },
  description: { type: DataTypes.TEXT },
  image_url: { type: DataTypes.STRING }
});

module.exports = Product;
