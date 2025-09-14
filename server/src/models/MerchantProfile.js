const mongoose = require('mongoose');

const LocationSchema = new mongoose.Schema(
  {
    lat: { type: Number, min: -90, max: 90, required: true },
    lng: { type: Number, min: -180, max: 180, required: true },
  },
  { _id: false }
);

const MerchantProfileSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
      unique: true,
    },
    businessType: {
      type: String,
      enum: ['restaurant', 'grocery', 'pharmacy', 'bakery'],
      required: true,
      index: true,
    },
    restaurantName: { type: String, required: true, trim: true },
    ownerName: { type: String, required: true, trim: true },
    ownerPhone: { type: String, required: true, trim: true },
    description: { type: String, default: null },
    deliveryRadius: { type: Number, min: 0, required: true },
    address: { type: String, default: null },
    location: { type: LocationSchema, default: null },
    avatarUrl: { type: String, default: null },
    active: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model('MerchantProfile', MerchantProfileSchema);
