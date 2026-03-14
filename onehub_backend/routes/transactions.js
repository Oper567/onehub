const express = require('express');
const router = express.Router();
const Wallet = require('../models/Wallet'); // This must match the filename above exactly

router.post('/purchase', async (req, res) => {
  const { amount } = req.body;
  try {
    console.log(`Processing Escrow for $${amount}`);
    // In a real flow, we would find the user's wallet and update balances here
    res.status(200).json({ message: "Funds Locked in Escrow" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
