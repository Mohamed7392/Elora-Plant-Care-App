const MyPlant = require('../models/MyPlant');

// @desc    Get all user plants
// @route   GET /api/myplants
// @access  Private
exports.getMyPlants = async (req, res) => {
  try {
    const plants = await MyPlant.find({ user: req.user.id }).sort({ createdAt: -1 });
    res.json(plants);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @desc    Add multiple plants to user's list
// @route   POST /api/myplants
// @access  Private
exports.addMyPlants = async (req, res) => {
  const { plantIds, wateringFrequencyHours, productsData } = req.body;
  try {
    // productsData is an array of { id, name, imageUrl }
    const newPlants = [];
    for (const p of productsData) {
      if (plantIds.includes(p.id)) {
        const myPlant = new MyPlant({
          user: req.user.id,
          product: p.id,
          name: p.name,
          imageUrl: p.imageUrl,
          wateringFrequencyHours: wateringFrequencyHours
        });
        await myPlant.save();
        newPlants.push(myPlant);
      }
    }
    res.json(newPlants);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// @desc    Remove a plant from user's list
// @route   DELETE /api/myplants/:id
// @access  Private
exports.removeMyPlant = async (req, res) => {
  try {
    const plant = await MyPlant.findById(req.params.id);
    if (!plant) {
      return res.status(404).json({ msg: 'Plant not found' });
    }
    if (plant.user.toString() !== req.user.id) {
      return res.status(401).json({ msg: 'User not authorized' });
    }
    await plant.deleteOne();
    res.json({ msg: 'Plant removed' });
  } catch (err) {
    console.error(err.message);
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ msg: 'Plant not found' });
    }
    res.status(500).send('Server Error');
  }
};
