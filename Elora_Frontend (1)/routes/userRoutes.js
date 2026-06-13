const express = require('express');
const { body } = require('express-validator');
const router = express.Router();

const {
  signup,
  login,
  getUsers,
  getUser,
  updateUser,
  deleteUser
} = require('../controllers/userController');

const validate = require('../middlewares/validate');

router.post(
  '/signup',
  [
    body('name', 'Name is required').notEmpty(),
    body('email', 'Please include a valid email').isEmail(),
    body('password', 'Please enter a password with 6 or more characters').isLength({ min: 6 })
  ],
  validate,
  signup
);

router.post(
  '/login',
  [
    body('email', 'Please include a valid email').isEmail(),
    body('password', 'Password is required').exists()
  ],
  validate,
  login
);

router.get('/', getUsers);
router.get('/:id', getUser);
router.put('/:id', updateUser);
router.delete('/:id', deleteUser);

module.exports = router;
