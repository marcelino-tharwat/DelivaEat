const Category = require('../models/Category');
const Restaurant = require('../models/Restaurant');
const Food = require('../models/Food');
const { validationResult } = require('express-validator');

// @desc    Global search across restaurants and foods
// @route   GET /api/search?q=query&lang=ar&type=all&limit=20&page=1
// @access  Public
const globalSearch = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid search parameters',
          details: errors.array()
        }
      });
    }

    const { 
      q: query = '', 
      lang = 'ar', 
      type = 'all', 
      limit = 20, 
      page = 1,
      category = null,
      minRating = null,
      maxPrice = null,
      minPrice = null
    } = req.query;

    if (!query.trim()) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'EMPTY_QUERY',
          message: 'Search query cannot be empty'
        }
      });
    }

    const searchRegex = new RegExp(query, 'i');
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const limitNum = parseInt(limit);

    let results = {
      restaurants: [],
      foods: [],
      total: 0,
      page: parseInt(page),
      totalPages: 0
    };

    // Search in restaurants
    if (type === 'all' || type === 'restaurants') {
      const nameField = lang === 'ar' ? 'nameAr' : 'name';
      const descField = lang === 'ar' ? 'descriptionAr' : 'description';
      
      let restaurantQuery = {
        isActive: true,
        isOpen: true,
        $or: [
          { [nameField]: searchRegex },
          { [descField]: searchRegex },
          { name: searchRegex },
          { nameAr: searchRegex }
        ]
      };

      if (minRating) {
        restaurantQuery.rating = { $gte: parseFloat(minRating) };
      }

      if (category) {
        restaurantQuery.categories = category;
      }

      const restaurants = await Restaurant.find(restaurantQuery)
        .sort({ rating: -1 })
        .skip(type === 'restaurants' ? skip : 0)
        .limit(type === 'restaurants' ? limitNum : 10)
        .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee`)
        .lean();

      results.restaurants = restaurants;
    }

    // Search in foods
    if (type === 'all' || type === 'foods') {
      const nameField = lang === 'ar' ? 'nameAr' : 'name';
      const descField = lang === 'ar' ? 'descriptionAr' : 'description';
      
      let foodQuery = {
        isAvailable: true,
        $or: [
          { [nameField]: searchRegex },
          { [descField]: searchRegex },
          { name: searchRegex },
          { nameAr: searchRegex },
          { tags: searchRegex },
          { ingredients: searchRegex }
        ]
      };

      if (minRating) {
        foodQuery.rating = { $gte: parseFloat(minRating) };
      }

      if (minPrice || maxPrice) {
        foodQuery.price = {};
        if (minPrice) foodQuery.price.$gte = parseFloat(minPrice);
        if (maxPrice) foodQuery.price.$lte = parseFloat(maxPrice);
      }

      if (category) {
        foodQuery.category = category;
      }

      const foods = await Food.find(foodQuery)
        .populate('restaurant', `name${lang === 'ar' ? 'Ar' : ''} name nameAr image rating`)
        .sort({ rating: -1, isBestSelling: -1 })
        .skip(type === 'foods' ? skip : 0)
        .limit(type === 'foods' ? limitNum : 10)
        .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image price originalPrice rating preparationTime tags`)
        .lean();

      results.foods = foods;
    }

    // Calculate totals for pagination
    if (type === 'restaurants') {
      const totalRestaurants = await Restaurant.countDocuments({
        isActive: true,
        isOpen: true,
        $or: [
          { [`name${lang === 'ar' ? 'Ar' : ''}`]: searchRegex },
          { [`description${lang === 'ar' ? 'Ar' : ''}`]: searchRegex }
        ]
      });
      results.total = totalRestaurants;
      results.totalPages = Math.ceil(totalRestaurants / limitNum);
    } else if (type === 'foods') {
      const totalFoods = await Food.countDocuments({
        isAvailable: true,
        $or: [
          { [`name${lang === 'ar' ? 'Ar' : ''}`]: searchRegex },
          { [`description${lang === 'ar' ? 'Ar' : ''}`]: searchRegex },
          { tags: searchRegex }
        ]
      });
      results.total = totalFoods;
      results.totalPages = Math.ceil(totalFoods / limitNum);
    } else {
      results.total = results.restaurants.length + results.foods.length;
    }

    res.json({
      success: true,
      data: results
    });

  } catch (error) {
    console.error('Error in global search:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to perform search'
      }
    });
  }
};

// @desc    Search suggestions/autocomplete
// @route   GET /api/search/suggestions?q=query&lang=ar&limit=5
// @access  Public
const getSearchSuggestions = async (req, res) => {
  try {
    const { q: query = '', lang = 'ar', limit = 5 } = req.query;

    if (!query.trim()) {
      return res.json({
        success: true,
        data: []
      });
    }

    const searchRegex = new RegExp(`^${query}`, 'i');
    const limitNum = parseInt(limit);

    // Get restaurant suggestions
    const restaurantSuggestions = await Restaurant.find({
      isActive: true,
      isOpen: true,
      $or: [
        { [`name${lang === 'ar' ? 'Ar' : ''}`]: searchRegex },
        { name: searchRegex },
        { nameAr: searchRegex }
      ]
    })
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr image`)
      .limit(Math.ceil(limitNum / 2))
      .lean();

    // Get food suggestions
    const foodSuggestions = await Food.find({
      isAvailable: true,
      $or: [
        { [`name${lang === 'ar' ? 'Ar' : ''}`]: searchRegex },
        { name: searchRegex },
        { nameAr: searchRegex }
      ]
    })
      .populate('restaurant', `name${lang === 'ar' ? 'Ar' : ''} name nameAr`)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr image`)
      .limit(Math.floor(limitNum / 2))
      .lean();

    const suggestions = [
      ...restaurantSuggestions.map(r => ({
        id: r._id,
        name: lang === 'ar' ? r.nameAr : r.name,
        type: 'restaurant',
        image: r.image
      })),
      ...foodSuggestions.map(f => ({
        id: f._id,
        name: lang === 'ar' ? f.nameAr : f.name,
        type: 'food',
        image: f.image,
        restaurant: f.restaurant ? (lang === 'ar' ? f.restaurant.nameAr : f.restaurant.name) : null
      }))
    ];

    res.json({
      success: true,
      data: suggestions
    });

  } catch (error) {
    console.error('Error getting search suggestions:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get search suggestions'
      }
    });
  }
};

// @desc    Get popular search terms
// @route   GET /api/search/popular?lang=ar&limit=10
// @access  Public
const getPopularSearches = async (req, res) => {
  try {
    const { lang = 'ar', limit = 10 } = req.query;
    
    // Get most popular food tags
    const popularTags = await Food.aggregate([
      { $match: { isAvailable: true } },
      { $unwind: '$tags' },
      { $group: { _id: '$tags', count: { $sum: 1 } } },
      { $sort: { count: -1 } },
      { $limit: parseInt(limit) },
      { $project: { _id: 0, term: '$_id', count: 1 } }
    ]);

    // Get top-rated restaurant names as popular searches
    const popularRestaurants = await Restaurant.find({
      isActive: true,
      isOpen: true,
      rating: { $gte: 4.5 }
    })
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr rating`)
      .sort({ rating: -1, reviewCount: -1 })
      .limit(5)
      .lean();

    const restaurantTerms = popularRestaurants.map(r => ({
      term: lang === 'ar' ? r.nameAr : r.name,
      count: r.rating * 10 // Simulate popularity based on rating
    }));

    const allPopularTerms = [...popularTags, ...restaurantTerms]
      .sort((a, b) => b.count - a.count)
      .slice(0, parseInt(limit));

    res.json({
      success: true,
      data: allPopularTerms
    });

  } catch (error) {
    console.error('Error getting popular searches:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get popular searches'
      }
    });
  }
};

module.exports = {
  globalSearch,
  getSearchSuggestions,
  getPopularSearches
};
