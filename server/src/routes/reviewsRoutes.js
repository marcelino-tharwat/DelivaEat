const express = require('express');
const { getReviews, addReview } = require('../controllers/reviewsController');
const { auth } = require('../middleware/auth');

const router = express.Router();

// Public list of reviews
router.get('/', getReviews);

// Optional: protected create
router.post('/', auth, addReview);

module.exports = router;
