const Category = require('../models/Category');
const Restaurant = require('../models/Restaurant');
const Food = require('../models/Food');
const mongoose = require('mongoose');
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
        let catVal = category;
        // allow name or ObjectId
        const isHex24 = typeof catVal === 'string' && /^[0-9a-fA-F]{24}$/.test(catVal);
        if (!isHex24) {
          const byName = await Category.findOne({
            $or: [
              { name: { $regex: `^${String(catVal).trim()}$`, $options: 'i' } },
              { nameAr: { $regex: `^${String(catVal).trim()}$`, $options: 'i' } },
            ],
          }).select('_id').lean();
          if (byName) catVal = String(byName._id);
        }
        restaurantQuery.categories = isHex24
          ? new mongoose.Types.ObjectId(String(catVal))
          : new mongoose.Types.ObjectId(String(catVal));
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
        let catVal = category;
        const isHex24 = typeof catVal === 'string' && /^[0-9a-fA-F]{24}$/.test(catVal);
        let pharmRoot = null;
        let groceryRoot = null;
        let marketsRoot = null;
        if (isHex24) {
          const c = await Category.findById(catVal).select('name nameAr').lean();
          if (c) {
            if (c.name === 'Pharmacies' || c.nameAr === 'صيدليات') pharmRoot = c;
            if (c.name === 'Grocery' || c.nameAr === 'بقالة') groceryRoot = c;
            if (c.name === 'Markets' || c.nameAr === 'أسواق') marketsRoot = c;
          }
        } else {
          const byName = await Category.findOne({
            $or: [
              { name: { $regex: `^${String(catVal).trim()}$`, $options: 'i' } },
              { nameAr: { $regex: `^${String(catVal).trim()}$`, $options: 'i' } },
            ],
          }).select('_id name nameAr').lean();
          if (byName) {
            catVal = String(byName._id);
            if (byName.name === 'Pharmacies' || byName.nameAr === 'صيدليات') pharmRoot = byName;
            if (byName.name === 'Grocery' || byName.nameAr === 'بقالة') groceryRoot = byName;
            if (byName.name === 'Markets' || byName.nameAr === 'أسواق') marketsRoot = byName;
          }
        }

        if (pharmRoot || groceryRoot || marketsRoot) {
          // expand to pharmacy subcategories (EN + AR) and include both name and nameAr fields
          const namesEN = [];
          const namesAR = [];
          if (pharmRoot) {
            namesEN.push('Medicines','Supplements','Personal Care','Cosmetics','Mother & Baby Care','Medical Equipment');
            namesAR.push('أدوية','مكملات','العناية الشخصية','مستحضرات تجميل','العناية بالأم والطفل','الأدوات الطبية');
          }
          if (groceryRoot) {
            namesEN.push('Fruits & Vegetables','Dairy & Eggs','Meat & Poultry','Bakery','Beverages','Snacks');
            namesAR.push('فواكه وخضروات','ألبان وبيض','لحوم ودواجن','مخبوزات','مشروبات','سناكس');
          }
          if (marketsRoot) {
            namesEN.push('Fresh Produce','Organic Products','Beverages','Snacks','Household Items');
            namesAR.push('منتجات طازجة','منتجات عضوية','مشروبات','سناكس','منتجات منزلية');
          }
          const subcats = await Category.find({
            $or: [
              { name: { $in: namesEN } },
              { nameAr: { $in: namesAR } },
            ],
          }).select('_id').lean();
          const ids = subcats.map(s => s._id);
          // Safe fallback: if no subcategories found, limit to the Pharmacies root id to avoid mixing with food categories
          if (ids.length > 0) {
            foodQuery.category = { $in: ids };
          } else {
            foodQuery.category = new mongoose.Types.ObjectId(String(catVal));
          }
        } else {
          foodQuery.category = new mongoose.Types.ObjectId(String(catVal));
        }
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
