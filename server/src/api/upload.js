const express = require('express');
const router = express.Router();

const { auth } = require('../middleware/auth');
const { upload } = require('../middleware/upload');
const { uploadImage, uploadAvatar } = require('../controllers/uploadController');

// Base path suggestion when mounting: app.use('/api/upload', uploadApi)
router.post('/image', upload.single('image'), uploadImage);
router.post('/avatar', auth, upload.single('image'), uploadAvatar);

module.exports = router;
