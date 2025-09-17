const mongoose = require('mongoose');

const LocationSchema = new mongoose.Schema(
  {
    lat: {
      type: Number,
      min: [-90, 'Latitude must be >= -90 (خط العرض يجب ألا يقل عن -90).'],
      max: [90, 'Latitude must be <= 90 (خط العرض يجب ألا يزيد عن 90).'],
      required: [true, 'Latitude is required (خط العرض مطلوب).'],
    },
    lng: {
      type: Number,
      min: [-180, 'Longitude must be >= -180 (خط الطول يجب ألا يقل عن -180).'],
      max: [180, 'Longitude must be <= 180 (خط الطول يجب ألا يزيد عن 180).'],
      required: [true, 'Longitude is required (خط الطول مطلوب).'],
    },
  },
  { _id: false }
);

const MerchantProfileSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User reference is required (معرّف المستخدم مطلوب).'],
      index: true,
      unique: true,
    },
    businessType: {
      type: String,
      enum: {
        values: ['restaurant', 'grocery', 'pharmacy', 'bakery'],
        message: 'Invalid business type (نوع النشاط غير صالح).',
      },
      required: [true, 'Business type is required (نوع النشاط مطلوب).'],
      index: true,
    },
    restaurantName: { type: String, required: [true, 'Restaurant name is required (اسم المطعم مطلوب).'], trim: true },
    ownerName: { type: String, required: [true, 'Owner name is required (اسم المالك مطلوب).'], trim: true },
    ownerPhone: { type: String, required: [true, 'Owner phone is required (هاتف المالك مطلوب).'], trim: true },
    description: { type: String, default: null },
    deliveryRadius: { type: Number, min: [0, 'Delivery radius must be >= 0 (نطاق التوصيل يجب ألا يقل عن 0).'], required: [true, 'Delivery radius is required (نطاق التوصيل مطلوب).'] },
    address: { type: String, default: null },
    location: { type: LocationSchema, default: null },
    avatarUrl: { type: String, default: null },
    active: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model('MerchantProfile', MerchantProfileSchema);
