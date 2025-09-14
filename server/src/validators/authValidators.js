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

module.exports = { registerValidator, loginValidator };
