const User = require('../models/User');
const MerchantProfile = require('../models/MerchantProfile');

async function createMerchantDraft(req, res, next) {
  try {
    const payload = req.body || {};

    // Check existing user by email
    const existing = await User.findOne({ email: payload.email });
    if (existing) {
      return res.status(409).json({
        success: false,
        error: { code: 'EMAIL_TAKEN', message: 'Email already in use' },
      });
    }

    // Create user with role merchant
    const user = await User.create({
      name: payload.name,
      email: payload.email,
      password: payload.password,
      phone: payload.phone ?? null,
      role: 'merchant',
      avatarUrl: payload.avatarUrl ?? null,
    });

    // Create merchant profile
    const merchant = await MerchantProfile.create({
      userId: user._id,
      businessType: payload.businessType,
      restaurantName: payload.restaurantName,
      ownerName: payload.ownerName,
      ownerPhone: payload.ownerPhone,
      description: payload.description ?? null,
      deliveryRadius: payload.deliveryRadius,
      address: payload.address ?? null,
      location: payload.location ?? null,
      avatarUrl: payload.avatarUrl ?? null,
    });

    return res.status(201).json({
      success: true,
      data: {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone ?? null,
          avatarUrl: user.avatarUrl ?? null,
          role: user.role,
          createdAt: user.createdAt,
        },
        merchant,
      },
    });
  } catch (err) {
    return next(err);
  }
}

async function getMyMerchantProfile(req, res, next) {
  try {
    // If needed later: fetch from DB by req.user.id
    return res.json({ success: true, data: { merchant: { id: 'stub', name: req.user?.name ?? 'Merchant', role: 'merchant' } } });
  } catch (err) {
    return next(err);
  }
}

module.exports = { createMerchantDraft, getMyMerchantProfile };
