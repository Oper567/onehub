const express = require('express');
const router = express.Router();
const Message = require('../models/Message');

// Get all messages (In a full production app, this would filter by user ID)
router.get('/', async (req, res) => {
  try {
    const messages = await Message.findAll({ 
      order: [['createdAt', 'DESC']] 
    });
    res.json(messages);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Send a new message
router.post('/', async (req, res) => {
  const { senderId, receiverId, content } = req.body;
  try {
    const newMessage = await Message.create({ senderId, receiverId, content });
    res.status(201).json(newMessage);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
