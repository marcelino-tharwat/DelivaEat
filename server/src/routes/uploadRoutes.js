const express = require('express');
const { auth } = require('../middleware/auth');
const { upload } = require('../middleware/upload');
const { uploadImage, uploadAvatar } = require('../controllers/uploadController');

const router = express.Router();

// Public image upload (if you want it private, add auth here as well)
router.post('/image', upload.single('image'), uploadImage);

// Protected: upload and set current user's avatar
router.post('/avatar', auth, upload.single('image'), uploadAvatar);

module.exports = router;
