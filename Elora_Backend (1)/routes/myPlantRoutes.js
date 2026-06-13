const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');

const {
  getMyPlants,
  addMyPlants,
  removeMyPlant
} = require('../controllers/myPlantController');

// All myPlant routes require authentication
router.use(auth);

router.get('/', getMyPlants);
router.post('/', addMyPlants);
router.delete('/:id', removeMyPlant);

module.exports = router;
