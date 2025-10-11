const mongoose = require('mongoose');

const ReviewSchema = new mongoose.Schema(
  {
    foodId: { type: mongoose.Schema.Types.ObjectId, ref: 'Food', index: true },
    restaurantId: { type: mongoose.Schema.Types.ObjectId, ref: 'Restaurant', index: true },
    userName: { type: String, default: 'Anonymous' },
    rating: { type: Number, min: 1, max: 5, required: true },
    comment: { type: String, default: '' },
  },
  { timestamps: true }
);

ReviewSchema.index({ foodId: 1, createdAt: -1 });
ReviewSchema.index({ restaurantId: 1, createdAt: -1 });

module.exports = mongoose.model('Review', ReviewSchema);
