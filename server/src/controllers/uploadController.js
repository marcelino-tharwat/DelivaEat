const User = require('../models/User');

// After multer-storage-cloudinary, req.file has:
// - path: Cloudinary URL
// - filename: Cloudinary public_id
async function uploadImage(req, res, next) {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: { code: 'NO_FILE', message: 'No image file uploaded. Use form field name "image".' },
      });
    }
    const { path: url, filename: publicId } = req.file;
    return res.status(201).json({ success: true, data: { url, publicId } });
  } catch (err) {
    return next(err);
  }
}

async function uploadAvatar(req, res, next) {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: { code: 'NO_FILE', message: 'No image file uploaded. Use form field name "image".' },
      });
    }
    const { path: url } = req.file;

    // Update current user's avatarUrl
    req.user.avatarUrl = url;
    await req.user.save({ validateModifiedOnly: true });

    return res.status(200).json({ success: true, data: { user: req.user } });
  } catch (err) {
    return next(err);
  }
}

module.exports = { uploadImage, uploadAvatar };
