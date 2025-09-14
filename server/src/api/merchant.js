const express = require('express');
const router = express.Router();

const { auth } = require('../middleware/auth');
const { requireRole } = require('../middleware/roles');
const { createMerchantValidator } = require('../validators/merchantValidators');
const { createMerchantDraft, getMyMerchantProfile } = require('../controllers/merchantController');
const { normalizeFlutterEnums } = require('../middleware/normalize');
const { validate } = require('../middleware/validate');

// Suggested mount: app.use('/api/merchant', merchantApi)

// Create merchant draft/profile from signup payload (no wiring to DB yet)
router.post('/register', normalizeFlutterEnums, createMerchantValidator, validate, createMerchantDraft);

// Get current merchant profile (placeholder), protected
router.get('/me', auth, requireRole('merchant'), getMyMerchantProfile);

module.exports = router;
