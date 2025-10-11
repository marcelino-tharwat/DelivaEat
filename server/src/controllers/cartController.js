// Minimal Cart Controller with Mongo persistence
const Cart = require('../models/Cart');

const addItemToCart = async (req, res) => {
  try {
    const { foodId, quantity = 1, options = [] } = req.body || {};
    const { lang } = req.query || {};

    if (!foodId || typeof foodId !== 'string' || foodId.trim() === '') {
      return res
        .status(400)
        .json({ success: false, error: { message: 'foodId is required' } });
    }

    const ownerKey = (req.user && req.user.id) || 'global';
    const item = {
      foodId: String(foodId),
      quantity: Number(quantity) || 1,
      options: Array.isArray(options) ? options : [],
      addedAt: new Date(),
    };

    let cart = await Cart.findOne({ ownerKey });
    if (!cart) {
      cart = await Cart.create({ ownerKey, items: [item] });
    } else {
      cart.items.unshift(item);
      await cart.save();
    }

    return res.json({ success: true, data: item });
  } catch (e) {
    return res
      .status(500)
      .json({ success: false, error: { message: e.message || 'Server error' } });
  }
};

const getCart = async (req, res) => {
  try {
    const ownerKey = (req.user && req.user.id) || 'global';
    const cart = await Cart.findOne({ ownerKey });
    return res.json({ success: true, data: cart || { ownerKey, items: [] } });
  } catch (e) {
    return res.status(500).json({ success: false, error: { message: e.message || 'Server error' } });
  }
};

const updateItemQuantity = async (req, res) => {
  try {
    const ownerKey = (req.user && req.user.id) || 'global';
    const { id } = req.params; // item id (generated client/server)
    const { quantity } = req.body || {};
    if (!id || !quantity || Number(quantity) < 1) {
      return res.status(400).json({ success: false, error: { message: 'Invalid id or quantity' } });
    }
    const cart = await Cart.findOne({ ownerKey });
    if (!cart) return res.status(404).json({ success: false, error: { message: 'Cart not found' } });
    const item = cart.items.id(id) || cart.items.find((it) => String(it._id) === String(id));
    if (!item) return res.status(404).json({ success: false, error: { message: 'Item not found' } });
    item.quantity = Number(quantity);
    await cart.save();
    return res.json({ success: true, data: item });
  } catch (e) {
    return res.status(500).json({ success: false, error: { message: e.message || 'Server error' } });
  }
};

const removeItem = async (req, res) => {
  try {
    const ownerKey = (req.user && req.user.id) || 'global';
    const { id } = req.params;
    const cart = await Cart.findOne({ ownerKey });
    if (!cart) return res.status(404).json({ success: false, error: { message: 'Cart not found' } });
    const before = cart.items.length;
    cart.items = cart.items.filter((it) => String(it._id) !== String(id));
    if (cart.items.length === before) {
      return res.status(404).json({ success: false, error: { message: 'Item not found' } });
    }
    await cart.save();
    return res.json({ success: true, data: { id } });
  } catch (e) {
    return res.status(500).json({ success: false, error: { message: e.message || 'Server error' } });
  }
};

module.exports = { addItemToCart, getCart, updateItemQuantity, removeItem };
