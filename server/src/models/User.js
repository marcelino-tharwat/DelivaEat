const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const UserSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      trim: true,
      required: [true, 'Name is required (الاسم مطلوب).'],
      minlength: [2, 'Name must be at least 2 characters (الاسم يجب ألا يقل عن حرفين).'],
      maxlength: [80, 'Name must be at most 80 characters (الاسم يجب ألا يزيد عن 80 حرفاً).'],
    },
    email: {
      type: String,
      required: [true, 'Email is required (البريد الإلكتروني مطلوب).'],
      unique: true,
      lowercase: true,
      match: [/[^@\s]+@[^@\s]+\.[^@\s]+/, 'Invalid email format (صيغة البريد الإلكتروني غير صحيحة).'],
    },
    password: {
      type: String,
      required: [true, 'Password is required (كلمة المرور مطلوبة).'],
      minlength: [6, 'Password must be at least 6 characters (كلمة المرور يجب ألا تقل عن 6 أحرف).'],
      select: false,
    },
    phone: {
      type: String,
      default: null,
      trim: true,
    },
    avatarUrl: {
      type: String,
      default: null,
    },
    role: {
      type: String,
      enum: {
        values: ['user', 'rider', 'merchant', 'admin'],
        message: 'Invalid role (دور المستخدم غير صالح).',
      },
      default: 'user',
    },
    // Password reset support
    resetCode: {
      type: String,
      default: null,
      select: false,
    },
    resetCodeExpires: {
      type: Date,
      default: null,
      select: false,
    },
  },
  { timestamps: true }
);

UserSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

UserSchema.methods.comparePassword = async function (candidate) {
  return bcrypt.compare(candidate, this.password);
};

module.exports = mongoose.model('User', UserSchema);