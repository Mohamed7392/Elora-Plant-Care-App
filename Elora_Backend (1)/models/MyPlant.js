const mongoose = require('mongoose');

const myPlantSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  product: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true
  },
  name: {
    type: String,
    required: true
  },
  imageUrl: {
    type: String
  },
  lastWateredAt: {
    type: Date,
    default: Date.now
  },
  wateringFrequencyHours: {
    type: Number,
    required: true,
    default: 24
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('MyPlant', myPlantSchema);
