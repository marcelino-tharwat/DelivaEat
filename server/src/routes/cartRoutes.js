const express = require('express');
const { addItemToCart, getCart, updateItemQuantity, removeItem } = require('../controllers/cartController');
const { auth } = require('../middleware/auth');

const router = express.Router();

// @route   GET /api/cart
// @desc    Get current user's cart
// @access  Private
router.get('/', auth, getCart);

// @route   POST /api/cart/items
// @desc    Add item to cart
// @access  Private
router.post('/items', auth, addItemToCart);

// @route   PATCH /api/cart/items/:id
// @desc    Update item quantity
// @access  Private
router.patch('/items/:id', auth, updateItemQuantity);

// @route   DELETE /api/cart/items/:id
// @desc    Remove item from cart
// @access  Private
router.delete('/items/:id', auth, removeItem);

module.exports = router;
