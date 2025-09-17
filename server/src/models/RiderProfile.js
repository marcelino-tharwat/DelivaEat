const mongoose = require('mongoose');

const RiderProfileSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User reference is required (معرّف المستخدم مطلوب).'],
    },
    vehicleType: {
      type: String,
      enum: {
        values: ['motorcycle', 'bicycle', 'scooter'],
        message: 'Invalid vehicle type (نوع المركبة غير صالح).',
      },
      required: [true, 'Vehicle type is required (نوع المركبة مطلوب).'],
      index: true,
    },
    avatarUrl: { type: String, default: null },
    idCardUrl: { type: String, default: null },
    licenseUrl: { type: String, default: null },
    vehicleUrlFront: { type: String, default: null },
    vehicleUrlSide: { type: String, default: null },
    licensePlateUrl: { type: String, default: null },
    active: { type: Boolean, default: false },
  },
  { timestamps: true }
);

// Ensure single rider profile per user
RiderProfileSchema.index({ userId: 1 }, { unique: true });

module.exports = mongoose.model('RiderProfile', RiderProfileSchema);
