const { body } = require('express-validator');

const registerValidator = [
  body('name').isString().isLength({ min: 2 }).withMessage('Name is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('password')
    .isString()
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters'),
  body('phone').optional().isString().withMessage('Phone must be a string'),
  body('role').optional().isIn(['user', 'rider', 'merchant', 'admin']).withMessage('Invalid role'),
];

const loginValidator = [
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').isString().withMessage('Password is required'),
];

const googleLoginValidator = [
  body('idToken').isString().withMessage('idToken is required'),
];

const requestResetValidator = [
  body('email').isEmail().withMessage('Valid email is required'),
];

const verifyResetValidator = [
  body('email').isEmail().withMessage('Valid email is required'),
  body('code').isString().isLength({ min: 4, max: 8 }).withMessage('Code is required'),
];

const resetPasswordValidator = [
  body('email').isEmail().withMessage('Valid email is required'),
  body('code').isString().isLength({ min: 4, max: 8 }).withMessage('Code is required'),
  body('newPassword').isString().isLength({ min: 6 }).withMessage('New password must be at least 6 characters'),
];

module.exports = { registerValidator, loginValidator, googleLoginValidator, requestResetValidator, verifyResetValidator, resetPasswordValidator };
