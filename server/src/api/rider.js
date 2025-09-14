const express = require('express');
const router = express.Router();

const { auth } = require('../middleware/auth');
const { requireRole } = require('../middleware/roles');
const { createRiderValidator } = require('../validators/riderValidators');
const { createRiderDraft, getMyRiderProfile } = require('../controllers/riderController');
const { normalizeFlutterEnums } = require('../middleware/normalize');
const { validate } = require('../middleware/validate');

// Suggested mount: app.use('/api/rider', riderApi)

// Create rider draft/profile from signup payload (no DB wiring yet)
router.post('/register', normalizeFlutterEnums, createRiderValidator, validate, createRiderDraft);

// Get rider profile (placeholder), protected
router.get('/me', auth, requireRole('rider'), getMyRiderProfile);

module.exports = router;
