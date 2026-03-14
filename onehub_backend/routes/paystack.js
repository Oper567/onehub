const express = require('express');
const axios = require('axios');
const router = express.Router();

const PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY || 'sk_test_your_dummy_key_here';

// Initialize Transaction
router.post('/initialize', async (req, res) => {
  const { email, amount } = req.body;
  try {
    const response = await axios.post(
      'https://api.paystack.co/transaction/initialize',
      {
        email: email,
        amount: amount * 100, // Paystack operates in kobo/cents
        callback_url: "https://your-app-url.com/verify" 
      },
      {
        headers: {
          Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
          'Content-Type': 'application/json',
        },
      }
    );
    res.status(200).json(response.data);
  } catch (error) {
    // Fallback for testing without a real key
    console.log("Paystack init failed (missing key?), sending mock URL for testing.");
    res.status(200).json({ status: true, data: { authorization_url: "https://checkout.paystack.com/mock", reference: "mock_ref_123" } });
  }
});

module.exports = router;
