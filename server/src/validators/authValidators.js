const { body } = require('express-validator');

const registerValidator = [
  body('name')
    .trim()
    .isString()
    .isLength({ min: 2 })
    .withMessage('Name is required (الاسم مطلوب).')
    .escape(),
  body('email')
    .normalizeEmail()
    .isEmail()
    .withMessage('Valid email is required (يرجى إدخال بريد إلكتروني صحيح).'),
  body('password')
    .isString()
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters (كلمة المرور يجب ألا تقل عن 6 أحرف).'),
  body('phone')
    .optional()
    .isString()
    .withMessage('Phone must be a string (رقم الهاتف يجب أن يكون نصاً).'),
  body('role')
    .optional()
    .isIn(['user', 'rider', 'merchant', 'admin'])
    .withMessage('Invalid role (دور المستخدم غير صالح).'),
];

const loginValidator = [
  body('email')
    .normalizeEmail()
    .isEmail()
    .withMessage('Valid email is required (يرجى إدخال بريد إلكتروني صحيح).'),
  body('password')
    .isString()
    .notEmpty()
    .withMessage('Password is required (كلمة المرور مطلوبة).'),
];

const googleLoginValidator = [
  body('idToken').isString().notEmpty().withMessage('idToken is required (مطلوب معرف توكن جوجل).'),
];

const facebookLoginValidator = [
  body('accessToken').isString().notEmpty().withMessage('accessToken is required (مطلوب توكن فيسبوك).'),
];

const requestResetValidator = [
  body('email')
    .normalizeEmail()
    .isEmail()
    .withMessage('Valid email is required (يرجى إدخال بريد إلكتروني صحيح).'),
];

const verifyResetValidator = [
  body('email')
    .normalizeEmail()
    .isEmail()
    .withMessage('Valid email is required (يرجى إدخال بريد إلكتروني صحيح).'),
  body('code')
    .isString()
    .isLength({ min: 4, max: 8 })
    .withMessage('Code is required (الكود مطلوب).'),
];

const resetPasswordValidator = [
  body('email')
    .normalizeEmail()
    .isEmail()
    .withMessage('Valid email is required (يرجى إدخال بريد إلكتروني صحيح).'),
  body('code')
    .isString()
    .isLength({ min: 4, max: 8 })
    .withMessage('Code is required (الكود مطلوب).'),
  body('newPassword')
    .isString()
    .isLength({ min: 6 })
    .withMessage('New password must be at least 6 characters (كلمة المرور الجديدة يجب ألا تقل عن 6 أحرف).'),
];

module.exports = { registerValidator, loginValidator, googleLoginValidator, facebookLoginValidator, requestResetValidator, verifyResetValidator, resetPasswordValidator };
