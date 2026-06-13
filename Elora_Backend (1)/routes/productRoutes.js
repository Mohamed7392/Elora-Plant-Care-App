const express = require('express');
const { body } = require('express-validator');
const router = express.Router();

const {
  createProduct,
  getProducts,
  getProduct,
  updateProduct,
  deleteProduct
} = require('../controllers/productController');

const validate = require('../middlewares/validate');

router.post(
  '/',
  [
    body('name', 'Name is required').notEmpty(),
    body('price', 'Price is required and must be a number').isNumeric()
  ],
  validate,
  createProduct
);

router.get('/', getProducts);
router.get('/:id', getProduct);

router.put(
  '/:id',
  [
    body('price', 'Price must be a number').optional().isNumeric(),
    body('stock', 'Stock must be a number').optional().isNumeric()
  ],
  validate,
  updateProduct
);

router.delete('/:id', deleteProduct);

module.exports = router;
