const Review = require('../models/Review');
const Food = require('../models/Food');
const Restaurant = require('../models/Restaurant');

// GET /api/reviews
// query: foodId | restaurantId, limit=20, page=1
async function getReviews(req, res) {
  try {
    const { foodId, restaurantId, limit = 20, page = 1 } = req.query || {};
    const lim = Math.min(parseInt(limit) || 20, 100);
    const skip = (Math.max(parseInt(page) || 1, 1) - 1) * lim;

    if (!foodId && !restaurantId) {
      return res.status(400).json({ success: false, error: { message: 'foodId or restaurantId is required' } });
    }

    const filter = {};
    if (foodId) filter.foodId = foodId;
    if (restaurantId) filter.restaurantId = restaurantId;

    const [items, total] = await Promise.all([
      Review.find(filter).sort({ createdAt: -1 }).skip(skip).limit(lim).lean(),
      Review.countDocuments(filter),
    ]);

    return res.json({ success: true, data: { items, total, page: parseInt(page) || 1, limit: lim } });
  } catch (e) {
    return res.status(500).json({ success: false, error: { message: e.message || 'Server error' } });
  }
}

// Optional: POST a review (requires auth ideally)
async function addReview(req, res) {
  try {
    const { foodId, restaurantId, rating, comment } = req.body || {};
    if ((!foodId && !restaurantId) || !rating) {
      return res.status(400).json({ success: false, error: { message: 'rating and foodId or restaurantId are required' } });
    }
    const doc = await Review.create({
      foodId: foodId || undefined,
      restaurantId: restaurantId || undefined,
      userName: req.user?.name || 'Anonymous',
      rating: Number(rating),
      comment: comment || '',
    });
    return res.json({ success: true, data: doc });
  } catch (e) {
    return res.status(500).json({ success: false, error: { message: e.message || 'Server error' } });
  }
}

module.exports = { getReviews, addReview };
