const express = require('express');
const router = express.Router();

const { registerValidator, loginValidator } = require('../validators/authValidators');
const { register, login, me } = require('../controllers/authController');
const { auth } = require('../middleware/auth');
const { normalizeFlutterEnums } = require('../middleware/normalize');
const { validate } = require('../middleware/validate');

// Base path suggestion when mounting: app.use('/api/auth', authApi)
router.post('/register', normalizeFlutterEnums, registerValidator, validate, register);
router.post('/login', normalizeFlutterEnums, loginValidator, validate, login);
router.get('/me', auth, me);

module.exports = router;
