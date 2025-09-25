const Category = require('../models/Category');
const Offer = require('../models/Offer');
const Restaurant = require('../models/Restaurant');
const Food = require('../models/Food');
const { validationResult } = require('express-validator');

// @desc    Get home page data
// @route   GET /api/home
// @access  Public
const getHomeData = async (req, res) => {
  try {
    const lang = req.query.lang || 'ar';
    
    // Get categories
    const categories = await Category.find({ isActive: true })
      .sort({ order: 1 })
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr icon color gradient order`)
      .lean();

    // Get active offers
    const offers = await Offer.find({
      isActive: true,
      startDate: { $lte: new Date() },
      endDate: { $gte: new Date() }
    })
      .sort({ order: 1 })
      .select(`title${lang === 'ar' ? 'Ar' : ''} subtitle${lang === 'ar' ? 'Ar' : ''} title titleAr subtitle subtitleAr color icon image discount discountType`)
      .lean();

    // Get favorite restaurants
    const favoriteRestaurants = await Restaurant.find({
      isActive: true,
      isOpen: true,
      isFavorite: true
    })
      .sort({ rating: -1 })
      .limit(10)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr image rating deliveryTime deliveryFee`)
      .lean();

    // Get top rated restaurants
    const topRatedRestaurants = await Restaurant.find({
      isActive: true,
      isOpen: true,
      isTopRated: true
    })
      .sort({ rating: -1 })
      .limit(10)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee`)
      .lean();

    // Get best selling foods
    const bestSellingFoods = await Food.find({
      isAvailable: true,
      isBestSelling: true
    })
      .sort({ rating: -1 })
      .limit(15)
      .populate('restaurant', `name${lang === 'ar' ? 'Ar' : ''} name nameAr image rating`)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr image price originalPrice rating preparationTime`)
      .lean();

    res.json({
      success: true,
      data: {
        categories,
        offers,
        favoriteRestaurants,
        topRatedRestaurants,
        bestSellingFoods
      }
    });

  } catch (error) {
    console.error('Error getting home data:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get home data'
      }
    });
  }
};

// @desc    Get categories
// @route   GET /api/home/categories
// @access  Public
const getCategories = async (req, res) => {
  try {
    const lang = req.query.lang || 'ar';
    
    const categories = await Category.find({ isActive: true })
      .sort({ order: 1 })
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr icon color gradient order`)
      .lean();

    res.json({
      success: true,
      data: categories
    });

  } catch (error) {
    console.error('Error getting categories:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get categories'
      }
    });
  }
};

// @desc    Get active offers
// @route   GET /api/home/offers
// @access  Public
const getOffers = async (req, res) => {
  try {
    const lang = req.query.lang || 'ar';
    
    const offers = await Offer.find({
      isActive: true,
      startDate: { $lte: new Date() },
      endDate: { $gte: new Date() }
    })
      .sort({ order: 1 })
      .select(`title${lang === 'ar' ? 'Ar' : ''} subtitle${lang === 'ar' ? 'Ar' : ''} title titleAr subtitle subtitleAr color icon image discount discountType`)
      .lean();

    res.json({
      success: true,
      data: offers
    });

  } catch (error) {
    console.error('Error getting offers:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get offers'
      }
    });
  }
};

// @desc    Get restaurants by type
// @route   GET /api/home/restaurants
// @access  Public
const getRestaurants = async (req, res) => {
  try {
    const { type = 'all', limit = 10, lang = 'ar' } = req.query;
    
    let filter = {
      isActive: true,
      isOpen: true
    };

    if (type === 'favorite') {
      filter.isFavorite = true;
    } else if (type === 'topRated') {
      filter.isTopRated = true;
    }

    const restaurants = await Restaurant.find(filter)
      .sort({ rating: -1 })
      .limit(parseInt(limit))
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee`)
      .lean();

    res.json({
      success: true,
      data: restaurants
    });

  } catch (error) {
    console.error('Error getting restaurants:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get restaurants'
      }
    });
  }
};

// @desc    Get best selling foods
// @route   GET /api/home/foods/best-selling
// @access  Public
const getBestSellingFoods = async (req, res) => {
  try {
    const { limit = 15, lang = 'ar' } = req.query;
    
    const foods = await Food.find({
      isAvailable: true,
      isBestSelling: true
    })
      .sort({ rating: -1 })
      .limit(parseInt(limit))
      .populate('restaurant', `name${lang === 'ar' ? 'Ar' : ''} name nameAr image rating`)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr image price originalPrice rating preparationTime`)
      .lean();

    res.json({
      success: true,
      data: foods
    });

  } catch (error) {
    console.error('Error getting best selling foods:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get best selling foods'
      }
    });
  }
};

module.exports = {
  getHomeData,
  getCategories,
  getOffers,
  getRestaurants,
  getBestSellingFoods
};
