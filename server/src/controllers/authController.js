const { validationResult } = require('express-validator');
const User = require('../models/User');
const { signToken } = require('../utils/jwt');
const { verifyGoogleIdToken } = require('../utils/google');
const RiderProfile = require('../models/RiderProfile');
const MerchantProfile = require('../models/MerchantProfile');

async function register(req, res, next) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: { code: 'VALIDATION_ERROR', message: 'Invalid input' },
        details: errors.array(),
      });
    }

    const { name, email, password, phone, role } = req.body;

    const exists = await User.findOne({ email });
    if (exists) {
      return res.status(409).json({
        success: false,
        error: { code: 'EMAIL_TAKEN', message: 'Email already in use' },
      });
    }

    // Note: allowing optional role from request; ensure this is acceptable for your security model
    const user = await User.create({ name, email, password, phone: phone ?? null, role: role ?? undefined });

    const token = signToken(user._id.toString());

    const safeUser = {
      id: user._id,
      name: user.name,
      email: user.email,
      phone: user.phone ?? null,
      avatarUrl: user.avatarUrl,
      role: user.role,
      createdAt: user.createdAt,
    };

    // Determine activation status for role-based users
    let isActive = true;
    if (user.role === 'rider') {
      const rp = await RiderProfile.findOne({ userId: user._id }).select('active');
      isActive = rp ? !!rp.active : false;
    } else if (user.role === 'merchant') {
      const mp = await MerchantProfile.findOne({ userId: user._id }).select('active');
      isActive = mp ? !!mp.active : false;
    }

    return res.status(201).json({ success: true, data: { user: safeUser, token, isActive } });
  } catch (err) {
    return next(err);
  }
}

async function login(req, res, next) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: { code: 'VALIDATION_ERROR', message: 'Invalid input' },
        details: errors.array(),
      });
    }

    const { email, password } = req.body;

    const user = await User.findOne({ email }).select('+password');
    if (!user) {
      return res.status(401).json({
        success: false,
        error: { code: 'INVALID_CREDENTIALS', message: 'Invalid credentials' },
      });
    }

    const valid = await user.comparePassword(password);
    if (!valid) {
      return res.status(401).json({
        success: false,
        error: { code: 'INVALID_CREDENTIALS', message: 'Invalid credentials' },
      });
    }

    const token = signToken(user._id.toString());

    const safeUser = {
      id: user._id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      role: user.role,
      createdAt: user.createdAt,
    };
    let isActive = true;
    if (user.role === 'rider') {
      const rp = await RiderProfile.findOne({ userId: user._id }).select('active');
      isActive = rp ? !!rp.active : false;
    } else if (user.role === 'merchant') {
      const mp = await MerchantProfile.findOne({ userId: user._id }).select('active');
      isActive = mp ? !!mp.active : false;
    }

    return res.json({ success: true, data: { user: safeUser, token, isActive } });
  } catch (err) {
    return next(err);
  }
}

async function me(req, res, next) {
  try {
    // req.user comes from auth middleware (decoded token + fetched user)
    let isActive = true;
    if (req.user?.role === 'rider') {
      const rp = await RiderProfile.findOne({ userId: req.user.id }).select('active');
      isActive = rp ? !!rp.active : false;
    } else if (req.user?.role === 'merchant') {
      const mp = await MerchantProfile.findOne({ userId: req.user.id }).select('active');
      isActive = mp ? !!mp.active : false;
    }
    return res.json({ success: true, data: { user: req.user, isActive } });
  } catch (err) {
    return next(err);
  }
}

module.exports = { register, login, me };

async function googleLogin(req, res, next) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: { code: 'VALIDATION_ERROR', message: 'Invalid input' },
        details: errors.array(),
      });
    }

    const { idToken } = req.body;

    const ticket = await verifyGoogleIdToken(idToken);
    if (!ticket) {
      return res.status(401).json({ success: false, error: { code: 'INVALID_GOOGLE_TOKEN', message: 'Invalid Google token' } });
    }

    const { email, name, picture } = ticket;
    if (!email) {
      return res.status(400).json({ success: false, error: { code: 'GOOGLE_NO_EMAIL', message: 'Google account has no email' } });
    }

    let user = await User.findOne({ email });
    if (!user) {
      // Create a user with a random password (won't be used)
      const randomPassword = Math.random().toString(36).slice(-12) + 'Aa1!';
      user = await User.create({
        name: name || email.split('@')[0],
        email,
        password: randomPassword,
        avatarUrl: picture || null,
        role: 'user',
      });
    }

    const token = signToken(user._id.toString());
    const safeUser = {
      id: user._id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      role: user.role,
      createdAt: user.createdAt,
    };

    return res.json({ success: true, data: { user: safeUser, token } });
  } catch (err) {
    return next(err);
  }
}

module.exports.googleLogin = googleLogin;
