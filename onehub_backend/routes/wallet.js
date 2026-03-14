const express = require('express');
const router = express.Router();
const Wallet = require('../models/Wallet');

// Get wallet details (For the project, we'll fetch a default wallet)
router.get('/', async (req, res) => {
  try {
    // In a real app, you'd find by userId from the JWT token
    let wallet = await Wallet.findOne();
    
    // If no wallet exists yet (first time), create one
    if (!wallet) {
      wallet = await Wallet.create({ 
        userId: '00000000-0000-0000-0000-000000000000',
        available_balance: 1500.0,
        escrow_balance: 200.0 
      });
    }
    
    res.json(wallet);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
