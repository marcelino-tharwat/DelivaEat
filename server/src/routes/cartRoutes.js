const express = require('express');
const { addItemToCart, getCart, updateItemQuantity, removeItem } = require('../controllers/cartController');
const { auth } = require('../middleware/auth');

const router = express.Router();

// @route   GET /api/cart
// @desc    Get current user's cart
// @access  Public (auth enforced at checkout, not here)
router.get('/', getCart);

// @route   POST /api/cart/items
// @desc    Add item to cart
// @access  Public (auth enforced at checkout, not here)
router.post('/items', addItemToCart);

// @route   PATCH /api/cart/items/:id
// @desc    Update item quantity
// @access  Public (auth enforced at checkout, not here)
router.patch('/items/:id', updateItemQuantity);

// @route   DELETE /api/cart/items/:id
// @desc    Remove item from cart
// @access  Public (auth enforced at checkout, not here)
router.delete('/items/:id', removeItem);

module.exports = router;
