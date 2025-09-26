const express = require('express');
const {
  getHomeData,
  getCategories,
  getOffers,
  getRestaurants,
  getBestSellingFoods,
  getRestaurantsByCategory,
  getFoodsByRestaurant
} = require('../controllers/homeController');

const router = express.Router();

// @route   GET /api/home
// @desc    Get all home page data
// @access  Public
router.get('/', getHomeData);

// @route   GET /api/home/categories
// @desc    Get categories
// @access  Public
router.get('/categories', getCategories);

// @route   GET /api/home/offers
// @desc    Get active offers
// @access  Public
router.get('/offers', getOffers);

// @route   GET /api/home/restaurants
// @desc    Get restaurants by type (query: type=favorite|topRated|all, limit=10)
// @access  Public
router.get('/restaurants', getRestaurants);

// @route   GET /api/home/restaurants/by-category
// @desc    Get restaurants by categoryId (query: categoryId, limit, random=true|false, sort=rating|topRated)
// @access  Public
router.get('/restaurants/by-category', getRestaurantsByCategory);

// @route   GET /api/home/foods/best-selling
// @desc    Get best selling foods
// @access  Public
router.get('/foods/best-selling', getBestSellingFoods);

// @route   GET /api/home/foods/by-restaurant
// @desc    Get foods for a specific restaurant (query: restaurantId, limit, lang)
// @access  Public
router.get('/foods/by-restaurant', getFoodsByRestaurant);

module.exports = router;
