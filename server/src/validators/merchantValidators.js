const { body } = require('express-validator');

const createMerchantValidator = [
  body('name').isString().isLength({ min: 2 }).withMessage('name is required'),
  body('email').isEmail().withMessage('valid email is required'),
  body('password').isString().isLength({ min: 6 }).withMessage('password min 6'),
  body('phone').isString().notEmpty().withMessage('phone is required'),
  body('role').optional().isIn(['merchant']).withMessage('role must be merchant'),

  body('businessType')
    .isIn(['restaurant', 'grocery', 'pharmacy', 'bakery'])
    .withMessage('invalid businessType'),
  body('restaurantName').isString().notEmpty().withMessage('restaurantName is required'),
  body('ownerName').isString().notEmpty().withMessage('ownerName is required'),
  body('ownerPhone').isString().notEmpty().withMessage('ownerPhone is required'),
  body('description').optional().isString(),
  body('deliveryRadius').isFloat({ gt: 0 }).withMessage('deliveryRadius must be > 0'),

  body('address').optional().isString(),
  body('location').optional().isObject(),
  body('location.lat').optional().isFloat({ min: -90, max: 90 }),
  body('location.lng').optional().isFloat({ min: -180, max: 180 }),

  body('avatarUrl').optional().isURL().withMessage('avatarUrl must be a valid URL'),
];

module.exports = { createMerchantValidator };
