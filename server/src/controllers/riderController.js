const User = require('../models/User');
const RiderProfile = require('../models/RiderProfile');

async function createRiderDraft(req, res, next) {
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

    // Create user with role rider
    const user = await User.create({
      name: payload.name,
      email: payload.email,
      password: payload.password,
      phone: payload.phone ?? null,
      role: 'rider',
      avatarUrl: payload.avatarUrl ?? null,
    });

    // Create rider profile
    const rider = await RiderProfile.create({
      userId: user._id,
      vehicleType: payload.vehicleType,
      avatarUrl: payload.avatarUrl ?? null,
      idCardUrl: payload.idCardUrl ?? null,
      licenseUrl: payload.licenseUrl ?? null,
      vehicleUrlFront: payload.vehicleUrlFront ?? null,
      vehicleUrlSide: payload.vehicleUrlSide ?? null,
      licensePlateUrl: payload.licensePlateUrl ?? null,
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
        rider,
      },
    });
  } catch (err) {
    return next(err);
  }
}

async function getMyRiderProfile(req, res, next) {
  try {
    // If needed later: fetch from DB by req.user.id
    return res.json({ success: true, data: { rider: { id: 'stub', name: req.user?.name ?? 'Rider', role: 'rider' } } });
  } catch (err) {
    return next(err);
  }
}

module.exports = { createRiderDraft, getMyRiderProfile };
