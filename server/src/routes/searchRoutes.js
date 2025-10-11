const express = require('express');
const { body, query } = require('express-validator');
const {
  globalSearch,
  getSearchSuggestions,
  getPopularSearches
} = require('../controllers/searchController');

const router = express.Router();

// Validation middleware
const searchValidation = [
  query('q')
    .optional()
    .isString()
    .isLength({ min: 1, max: 100 })
    .withMessage('Query must be between 1 and 100 characters'),
  query('lang')
    .optional()
    .isIn(['ar', 'en'])
    .withMessage('Language must be ar or en'),
  query('type')
    .optional()
    .isIn(['all', 'restaurants', 'foods'])
    .withMessage('Type must be all, restaurants, or foods'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 50 })
    .withMessage('Limit must be between 1 and 50'),
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  query('minRating')
    .optional()
    .isFloat({ min: 0, max: 5 })
    .withMessage('Rating must be between 0 and 5'),
  query('maxPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Max price must be positive'),
  query('minPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Min price must be positive')
];

// @route   GET /api/search
// @desc    Global search across restaurants and foods
// @access  Public
// Query params: q, lang, type, limit, page, category, minRating, maxPrice, minPrice
router.get('/', searchValidation, globalSearch);

// @route   GET /api/search/suggestions
// @desc    Get search suggestions/autocomplete
// @access  Public
// Query params: q, lang, limit, category
router.get('/suggestions', [
  query('q')
    .optional()
    .isString()
    .isLength({ min: 1, max: 50 })
    .withMessage('Query must be between 1 and 50 characters'),
  query('lang')
    .optional()
    .isIn(['ar', 'en'])
    .withMessage('Language must be ar or en'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 10 })
    .withMessage('Limit must be between 1 and 10'),
  query('category')
    .optional()
    .isString()
], getSearchSuggestions);

// @route   GET /api/search/popular
// @desc    Get popular search terms
// @access  Public
// Query params: lang, limit, category
router.get('/popular', [
  query('lang')
    .optional()
    .isIn(['ar', 'en'])
    .withMessage('Language must be ar or en'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 20 })
    .withMessage('Limit must be between 1 and 20'),
  query('category')
    .optional()
    .isString()
], getPopularSearches);

module.exports = router;
