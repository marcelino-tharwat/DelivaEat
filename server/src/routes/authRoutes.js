const express = require('express');
const router = express.Router();
const { registerValidator, loginValidator, googleLoginValidator, requestResetValidator, verifyResetValidator, resetPasswordValidator } = require('../validators/authValidators');
const { register, login, me } = require('../controllers/authController');
const { googleLogin, requestPasswordReset, verifyResetCode, resetPassword } = require('../controllers/authController');
const { auth } = require('../middleware/auth');

router.post('/register', registerValidator, register);
router.post('/login', loginValidator, login);
router.get('/me', auth, me);
router.post('/google', googleLoginValidator, googleLogin);
router.post('/password/request', requestResetValidator, requestPasswordReset);
router.post('/password/verify', verifyResetValidator, verifyResetCode);
router.post('/password/reset', resetPasswordValidator, resetPassword);

module.exports = router;
