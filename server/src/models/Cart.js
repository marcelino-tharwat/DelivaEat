const mongoose = require('mongoose');

const CartItemSchema = new mongoose.Schema(
  {
    foodId: { type: mongoose.Schema.Types.ObjectId, ref: 'Food', required: true },
    quantity: { type: Number, default: 1, min: 1 },
    options: [
      {
        code: { type: String, required: true },
        price: { type: Number, default: 0 },
      },
    ],
    addedAt: { type: Date, default: Date.now },
  }
);

const CartSchema = new mongoose.Schema(
  {
    ownerKey: { type: String, index: true, required: true }, // userId or device key
    items: { type: [CartItemSchema], default: [] },
  },
  { timestamps: true }
);

CartSchema.index({ ownerKey: 1 });

module.exports = mongoose.model('Cart', CartSchema);
