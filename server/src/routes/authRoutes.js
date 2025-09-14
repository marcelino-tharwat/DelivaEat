const express = require('express');
const router = express.Router();
const { registerValidator, loginValidator } = require('../validators/authValidators');
const { register, login, me } = require('../controllers/authController');
const { auth } = require('../middleware/auth');

router.post('/register', registerValidator, register);
router.post('/login', loginValidator, login);
router.get('/me', auth, me);

module.exports = router;
