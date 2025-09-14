const { validationResult } = require('express-validator');
const User = require('../models/User');
const { signToken } = require('../utils/jwt');

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

    return res.status(201).json({ success: true, data: { user: safeUser, token } });
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

    return res.json({ success: true, data: { user: safeUser, token } });
  } catch (err) {
    return next(err);
  }
}

async function me(req, res, next) {
  try {
    return res.json({ success: true, data: { user: req.user } });
  } catch (err) {
    return next(err);
  }
}

module.exports = { register, login, me };
