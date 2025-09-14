const { body } = require('express-validator');

const createRiderValidator = [
  body('name').isString().isLength({ min: 2 }).withMessage('name is required'),
  body('email').isEmail().withMessage('valid email is required'),
  body('password').isString().isLength({ min: 6 }).withMessage('password min 6'),
  body('phone').isString().notEmpty().withMessage('phone is required'),
  body('role').optional().isIn(['rider']).withMessage('role must be rider'),

  body('vehicleType').isIn(['motorcycle', 'bicycle', 'scooter']).withMessage('invalid vehicleType'),

  body('avatarUrl').optional().isURL(),
  body('idCardUrl').optional().isURL(),
  body('licenseUrl').optional().isURL(),
  body('vehicleUrlFront').optional().isURL(),
  body('vehicleUrlSide').optional().isURL(),
  body('licensePlateUrl').optional().isURL(),
];

module.exports = { createRiderValidator };
