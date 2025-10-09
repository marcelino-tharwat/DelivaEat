const Category = require('../models/Category');
const mongoose = require('mongoose');
const Offer = require('../models/Offer');
const Restaurant = require('../models/Restaurant');
const Food = require('../models/Food');

const formatCategoryResponse = (categories) =>
  categories.map((category) => {
    const { icon, image, ...rest } = category;
    return {
      ...rest,
      image: image ?? icon ?? '',
    };
  });

// @desc    Get restaurant details with dynamic tabs and badges
// @route   GET /api/home/restaurant/details
// @access  Public
const getRestaurantDetails = async (req, res) => {
  try {
    const { restaurantId, lang = 'ar' } = req.query;
    if (!restaurantId) {
      return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'restaurantId is required' } });
    }

    // Resolve roots
    const [foodRoot, groceryRoot, marketsRoot, pharmaciesRoot, rest] = await Promise.all([
      Category.findOne({ $or: [{ name: 'Food' }, { nameAr: 'طعام' }] }).select('_id').lean(),
      Category.findOne({ $or: [{ name: 'Grocery' }, { nameAr: 'بقالة' }] }).select('_id').lean(),
      Category.findOne({ $or: [{ name: 'Markets' }, { nameAr: 'أسواق' }] }).select('_id').lean(),
      Category.findOne({ $or: [{ name: 'Pharmacies' }, { nameAr: 'صيدليات' }] }).select('_id').lean(),
      Restaurant.findById(restaurantId)
        .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image coverImage rating reviewCount deliveryTime deliveryFee minimumOrder isOpen isActive isFavorite isTopRated address phone categories`)
        .lean(),
    ]);

    if (!rest) {
      return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Restaurant not found' } });
    }

    // Determine root type
    let rootType = 'Food';
    const cats = (rest.categories || []).map(String);
    if (pharmaciesRoot && cats.includes(String(pharmaciesRoot._id))) rootType = 'Pharmacies';
    else if (groceryRoot && cats.includes(String(groceryRoot._id))) rootType = 'Grocery';
    else if (marketsRoot && cats.includes(String(marketsRoot._id))) rootType = 'Markets';
    else if (foodRoot && cats.includes(String(foodRoot._id))) rootType = 'Food';

    // Tabs per type
    const tabsByType = {
      Food: ['Trending', 'Free', 'Soup', 'Appetizers', 'Pasta', 'Drinks'],
      Pharmacies: ['Trending', 'Medicines', 'Supplements', 'Personal Care', 'Cosmetics', 'Mother & Baby Care', 'Medical Equipment'],
      Grocery: ['Trending', 'Fruits & Vegetables', 'Dairy & Eggs', 'Meat & Poultry', 'Bakery', 'Beverages', 'Snacks'],
      Markets: ['Trending', 'Fresh Produce', 'Organic Products', 'Beverages', 'Snacks', 'Household Items'],
    };

    // Badges
    const badges = [];
    if (rest.isTopRated || (rest.rating || 0) >= 4.5) badges.push('trending');
    if ((rest.deliveryFee || 0) === 0) badges.push('free');

    return res.json({
      success: true,
      data: {
        restaurant: rest,
        type: rootType,
        tabs: tabsByType[rootType] || [],
        badges,
      },
    });
  } catch (error) {
    console.error('Error getting restaurant details:', error);
    return res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to get restaurant details' } });
  }
};
// @desc    Toggle food favorite flag (demo/global)
// @route   POST /api/home/foods/favorite
// @access  Public (for demo)
const toggleFavoriteFood = async (req, res) => {
  try {
    const { foodId } = req.body || {};
    if (!foodId) {
      return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'foodId is required' } });
    }
    const f = await Food.findById(foodId);
    if (!f) {
      return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Food not found' } });
    }
    f.isFavorite = !Boolean(f.isFavorite);
    await f.save();
    const lang = req.query.lang || 'ar';
    const fresh = await Food.findById(foodId)
      .populate('restaurant', `name${lang === 'ar' ? 'Ar' : ''} name nameAr image rating`)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image price originalPrice rating reviewCount preparationTime isAvailable isPopular isBestSelling isFavorite`)
      .lean();
    return res.json({ success: true, data: fresh });
  } catch (error) {
    console.error('Error toggling food favorite:', error);
    return res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR', message: 'Failed to toggle favorite' } });
  }
};
// @desc    Toggle restaurant favorite flag (demo/global)
// @route   POST /api/home/restaurants/favorite
// @access  Public (for demo). Attach auth if you want per-user control.
const toggleFavoriteRestaurant = async (req, res) => {
  try {
    const { restaurantId } = req.body || {};
    if (!restaurantId) {
      return res.status(400).json({
        success: false,
        error: { code: 'VALIDATION_ERROR', message: 'restaurantId is required' },
      });
    }

    const r = await Restaurant.findById(restaurantId);
    if (!r) {
      return res.status(404).json({
        success: false,
        error: { code: 'NOT_FOUND', message: 'Restaurant not found' },
      });
    }
    r.isFavorite = !Boolean(r.isFavorite);
    await r.save();

    // return minimal fields used by client
    const lang = req.query.lang || 'ar';
    const fresh = await Restaurant.findById(restaurantId)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr image rating reviewCount deliveryTime deliveryFee minimumOrder isOpen isActive isFavorite isTopRated address phone`)
      .lean();

    return res.json({ success: true, data: fresh });
  } catch (error) {
    console.error('Error toggling favorite:', error);
    return res.status(500).json({
      success: false,
      error: { code: 'INTERNAL_ERROR', message: 'Failed to toggle favorite' },
    });
  }
};

// @desc    Get all home page data
// @route   GET /api/home
// @access  Public
const getHomeData = async (req, res) => {
  try {
    const lang = req.query.lang || 'ar';

    // Get categories
    const rawCategories = await Category.find({ isActive: true })
      .sort({ order: 1 })
      .select(`_id name${lang === 'ar' ? 'Ar' : ''} name nameAr icon color gradient order image`)
      .lean();

    const categories = formatCategoryResponse(rawCategories);

    // Get active offers
    const offers = await Offer.find({
      isActive: true,
      startDate: { $lte: new Date() },
      endDate: { $gte: new Date() }
    })
      .sort({ order: 1 })
      .select(`title${lang === 'ar' ? 'Ar' : ''} subtitle${lang === 'ar' ? 'Ar' : ''} title titleAr subtitle subtitleAr color icon image discount discountType isActive startDate endDate order`)
      .lean();

    // Resolve root categories to enforce Food-only sections on home
    let foodRootId = null;
    let groceryRootId = null;
    let marketsRootId = null;
    let pharmaciesRootId = null;
    try {
      const [foodRoot, groceryRoot, marketsRoot, pharmaciesRoot] = await Promise.all([
        Category.findOne({ $or: [{ name: 'Food' }, { nameAr: 'طعام' }] }).select('_id').lean(),
        Category.findOne({ $or: [{ name: 'Grocery' }, { nameAr: 'بقالة' }] }).select('_id').lean(),
        Category.findOne({ $or: [{ name: 'Markets' }, { nameAr: 'أسواق' }] }).select('_id').lean(),
        Category.findOne({ $or: [{ name: 'Pharmacies' }, { nameAr: 'صيدليات' }] }).select('_id').lean(),
      ]);
      if (foodRoot) foodRootId = foodRoot._id;
      if (groceryRoot) groceryRootId = groceryRoot._id;
      if (marketsRoot) marketsRootId = marketsRoot._id;
      if (pharmaciesRoot) pharmaciesRootId = pharmaciesRoot._id;
    } catch (_) {}

    // Get favorite restaurants (Food-only if Food root exists)
    const favoriteFilter = {
      isActive: true,
      isOpen: true,
      isFavorite: true,
    };
    if (foodRootId) favoriteFilter.categories = foodRootId;

    const favoriteRestaurants = await Restaurant.find(favoriteFilter)
      .sort({ rating: -1 })
      .limit(10)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee minimumOrder isOpen isActive isFavorite isTopRated address phone`)
      .lean();

    // Get top rated restaurants (excluding pharmacies)
    // Build exclusion list for pharmacy categories (root + common subcategories in EN/AR)
    const pharmacyCategoryIds = [];
    try {
      const pharmRoot = await Category.findOne({
        $or: [
          { name: 'Pharmacies' },
          { nameAr: 'صيدليات' },
        ],
      }).select('_id').lean();
      if (pharmRoot) pharmacyCategoryIds.push(pharmRoot._id);

      const pharmSubNames = [
        'Medicines', 'Supplements', 'Personal Care', 'Cosmetics', 'Mother & Baby Care', 'Medical Equipment',
        'أدوية', 'مكملات', 'العناية الشخصية', 'مستحضرات تجميل', 'العناية بالأم والطفل', 'الأدوات الطبية',
      ];
      const pharmSubcats = await Category.find({
        $or: [
          { name: { $in: pharmSubNames } },
          { nameAr: { $in: pharmSubNames } },
        ],
      }).select('_id').lean();
      pharmacyCategoryIds.push(...pharmSubcats.map((s) => s._id));
    } catch (_) {
      // If anything fails, proceed without exclusions
    }

    const topRatedFilter = {
      isActive: true,
      isOpen: true,
      isTopRated: true,
    };
    // Food-only: if Food root exists, strictly include it; otherwise, just exclude pharmacies to be safe
    if (foodRootId) {
      topRatedFilter.categories = foodRootId;
    } else if (pharmacyCategoryIds.length > 0) {
      topRatedFilter.categories = { $nin: pharmacyCategoryIds };
    }

    const topRatedRestaurants = await Restaurant.find(topRatedFilter)
      .sort({ rating: -1 })
      .limit(10)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee minimumOrder isOpen isActive isFavorite isTopRated address phone`)
      .lean();

    // Get best selling foods (Food-only if Food root exists)
    const bestSellingFilter = {
      isAvailable: true,
      isBestSelling: true,
    };
    if (foodRootId) bestSellingFilter.category = foodRootId;

    const bestSellingFoods = await Food.find(bestSellingFilter)
      .sort({ rating: -1 })
      .limit(15)
      .populate('restaurant', `name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee minimumOrder isOpen isActive address phone`)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image price originalPrice rating reviewCount preparationTime isAvailable isPopular isBestSelling isFavorite ingredients allergens tags`)
      .lean();

    // Strict per-category restaurant sections (sorted by highest rating)
    const selectFields = `name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee minimumOrder isOpen isActive isFavorite isTopRated address phone`;

    const [foodRestaurants, groceryStores, marketStores, pharmacyStores] = await Promise.all([
      foodRootId
        ? Restaurant.find({ isActive: true, isOpen: true, categories: foodRootId }).sort({ rating: -1 }).limit(10).select(selectFields).lean()
        : Promise.resolve([]),
      groceryRootId
        ? Restaurant.find({ isActive: true, isOpen: true, categories: groceryRootId }).sort({ rating: -1 }).limit(10).select(selectFields).lean()
        : Promise.resolve([]),
      marketsRootId
        ? Restaurant.find({ isActive: true, isOpen: true, categories: marketsRootId }).sort({ rating: -1 }).limit(10).select(selectFields).lean()
        : Promise.resolve([]),
      pharmaciesRootId
        ? Restaurant.find({ isActive: true, isOpen: true, categories: pharmaciesRootId }).sort({ rating: -1 }).limit(10).select(selectFields).lean()
        : Promise.resolve([]),
    ]);

    res.json({
      success: true,
      data: {
        categories,
        offers,
        favoriteRestaurants,
        topRatedRestaurants,
        bestSellingFoods,
        foodRestaurants,
        groceryStores,
        marketStores,
        pharmacyStores
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

// @desc    Get foods by restaurant
// @route   GET /api/home/foods/by-restaurant
// @access  Public
const getFoodsByRestaurant = async (req, res) => {
  try {
    const { restaurantId, limit = 50, lang = 'ar', tab, type } = req.query;

    if (!restaurantId) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'restaurantId is required'
        }
      });
    }

    // Build dynamic filter by tab/type (for restaurant page sections)
    const baseFilter = { isAvailable: true, restaurant: restaurantId };

    // Infer restaurant root type if not provided
    let rootType = type;
    try {
      if (!rootType) {
        const [foodRoot, groceryRoot, marketsRoot, pharmaciesRoot, rest] = await Promise.all([
          Category.findOne({ $or: [{ name: 'Food' }, { nameAr: 'طعام' }] }).select('_id').lean(),
          Category.findOne({ $or: [{ name: 'Grocery' }, { nameAr: 'بقالة' }] }).select('_id').lean(),
          Category.findOne({ $or: [{ name: 'Markets' }, { nameAr: 'أسواق' }] }).select('_id').lean(),
          Category.findOne({ $or: [{ name: 'Pharmacies' }, { nameAr: 'صيدليات' }] }).select('_id').lean(),
          Restaurant.findById(restaurantId).select('categories deliveryFee isTopRated rating').lean(),
        ]);
        if (rest && rest.categories) {
          const cats = rest.categories.map(String);
          if (foodRoot && cats.includes(String(foodRoot._id))) rootType = 'Food';
          else if (groceryRoot && cats.includes(String(groceryRoot._id))) rootType = 'Grocery';
          else if (marketsRoot && cats.includes(String(marketsRoot._id))) rootType = 'Markets';
          else if (pharmaciesRoot && cats.includes(String(pharmaciesRoot._id))) rootType = 'Pharmacies';
        }
      }
    } catch (_) {}

    // Apply tab-specific filters
    if (tab) {
      const t = String(tab).trim();
      const tLower = t.toLowerCase();
      if (rootType === 'Food') {
        if (/^trending$/i.test(t)) {
          Object.assign(baseFilter, { $or: [{ isPopular: true }, { isBestSelling: true }] });
        } else if (/^free$/i.test(t)) {
          // Free delivery tab: keep items, client can display badge; optionally no extra filter
        } else {
          // Fallback: match by tag or name
          Object.assign(baseFilter, {
            $or: [
              { tags: { $elemMatch: { $regex: t, $options: 'i' } } },
              { name: { $regex: t, $options: 'i' } },
              { nameAr: { $regex: t, $options: 'i' } },
            ],
          });
        }
      } else if (rootType === 'Pharmacies') {
        // Map tab to pharmacy subcategory
        const pharmTabs = [
          { en: 'Medicines', ar: 'أدوية' },
          { en: 'Supplements', ar: 'مكملات' },
          { en: 'Personal Care', ar: 'العناية الشخصية' },
          { en: 'Cosmetics', ar: 'مستحضرات تجميل' },
          { en: 'Mother & Baby Care', ar: 'العناية بالأم والطفل' },
          { en: 'Medical Equipment', ar: 'الأدوات الطبية' },
        ];
        const match = pharmTabs.find((x) => x.en.toLowerCase() === tLower || x.ar === t);
        if (match) {
          const sub = await Category.findOne({ $or: [{ name: match.en }, { nameAr: match.ar }] }).select('_id').lean();
          if (sub) Object.assign(baseFilter, { category: sub._id });
        }
      } else if (rootType === 'Grocery') {
        const groTabs = [
          { en: 'Fruits & Vegetables', ar: 'فواكه وخضروات' },
          { en: 'Dairy & Eggs', ar: 'ألبان وبيض' },
          { en: 'Meat & Poultry', ar: 'لحوم ودواجن' },
          { en: 'Bakery', ar: 'مخبوزات' },
          { en: 'Beverages', ar: 'مشروبات' },
          { en: 'Snacks', ar: 'سناكس' },
        ];
        const match = groTabs.find((x) => x.en.toLowerCase() === tLower || x.ar === t);
        if (match) {
          const sub = await Category.findOne({ $or: [{ name: match.en }, { nameAr: match.ar }] }).select('_id').lean();
          if (sub) Object.assign(baseFilter, { category: sub._id });
        }
      } else if (rootType === 'Markets') {
        const mkTabs = [
          { en: 'Fresh Produce', ar: 'منتجات طازجة' },
          { en: 'Organic Products', ar: 'منتجات عضوية' },
          { en: 'Beverages', ar: 'مشروبات' },
          { en: 'Snacks', ar: 'سناكس' },
          { en: 'Household Items', ar: 'منتجات منزلية' },
        ];
        const match = mkTabs.find((x) => x.en.toLowerCase() === tLower || x.ar === t);
        if (match) {
          const sub = await Category.findOne({ $or: [{ name: match.en }, { nameAr: match.ar }] }).select('_id').lean();
          if (sub) Object.assign(baseFilter, { category: sub._id });
        }
      }
    }

    const foods = await Food.find(baseFilter)
      .sort({ rating: -1 })
      .limit(parseInt(limit))
      .select(
        `name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image price originalPrice rating reviewCount preparationTime isAvailable isPopular isBestSelling ingredients allergens tags`
      )
      .lean();

    res.json({ success: true, data: foods });
  } catch (error) {
    console.error('Error getting foods by restaurant:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get foods by restaurant'
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
    
    const rawCategories = await Category.find({ isActive: true })
      .sort({ order: 1 })
      .select(`_id name${lang === 'ar' ? 'Ar' : ''} name nameAr icon color gradient order`)
      .lean();

    const categories = formatCategoryResponse(rawCategories);

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
    const { type = 'all', limit = 10, lang = 'ar', categoryId } = req.query;
    
    let filter = {
      isActive: true,
      isOpen: true
    };

    if (type === 'favorite') {
      filter.isFavorite = true;
    } else if (type === 'topRated') {
      filter.isTopRated = true;
    }

    // Optional: constrain by category (id or name)
    if (categoryId) {
      const val = String(categoryId).trim();
      const isHex24 = /^[0-9a-fA-F]{24}$/.test(val);
      let catId = val;
      if (!isHex24) {
        const byName = await Category.findOne({
          $or: [
            { name: { $regex: `^${val}$`, $options: 'i' } },
            { nameAr: { $regex: `^${val}$`, $options: 'i' } },
          ],
        }).select('_id').lean();
        if (byName) catId = String(byName._id);
      }
      filter.categories = isHex24 ? new mongoose.Types.ObjectId(val) : new mongoose.Types.ObjectId(catId);
    } else {
      // No explicit category provided: default to Food-only scope for home usage
      try {
        const [foodRoot, groceryRoot, marketsRoot, pharmaciesRoot] = await Promise.all([
          Category.findOne({ $or: [{ name: 'Food' }, { nameAr: 'طعام' }] }).select('_id').lean(),
          Category.findOne({ $or: [{ name: 'Grocery' }, { nameAr: 'بقالة' }] }).select('_id').lean(),
          Category.findOne({ $or: [{ name: 'Markets' }, { nameAr: 'أسواق' }] }).select('_id').lean(),
          Category.findOne({ $or: [{ name: 'Pharmacies' }, { nameAr: 'صيدليات' }] }).select('_id').lean(),
        ]);
        if (foodRoot) {
          filter.categories = foodRoot._id;
        } else {
          const excludeIds = [groceryRoot?._id, marketsRoot?._id, pharmaciesRoot?._id].filter(Boolean);
          if (excludeIds.length) {
            filter.categories = { $nin: excludeIds };
          }
        }
      } catch (_) {
        // If lookup fails, proceed without additional filter
      }
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

// @desc    Get restaurants by category
// @route   GET /api/home/restaurants/by-category
// @access  Public
const getRestaurantsByCategory = async (req, res) => {
  try {
    let { categoryId, limit = 20, lang = 'ar', random = 'false', sort = 'rating' } = req.query;

    if (!categoryId) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'categoryId is required'
        }
      });
    }

    // Normalize categoryId: allow passing name/slug and resolve to ObjectId
    const isHex24 = typeof categoryId === 'string' && /^[0-9a-fA-F]{24}$/.test(categoryId);
    if (!isHex24) {
      const needle = String(categoryId || '').trim();
      const byName = await Category.findOne({
        $or: [
          { name: { $regex: `^${needle}$`, $options: 'i' } },
          { nameAr: { $regex: `^${needle}$`, $options: 'i' } },
        ],
      }).select('_id').lean();
      if (byName) {
        categoryId = String(byName._id);
      }
    }

    const filter = {
      isActive: true,
      isOpen: true,
      categories: isHex24 || typeof categoryId === 'string'
        ? new mongoose.Types.ObjectId(String(categoryId))
        : categoryId,
    };

    // If client asks for topRated, constrain results to only top-rated
    if (sort === 'topRated') {
      filter.isTopRated = true;
    }

    let query = Restaurant.find(filter)
      .select(`name${lang === 'ar' ? 'Ar' : ''} name nameAr description${lang === 'ar' ? 'Ar' : ''} description descriptionAr image rating reviewCount deliveryTime deliveryFee minimumOrder isOpen isActive isFavorite isTopRated address phone`)
      .lean();

    if (random === 'true') {
      // Randomize by using aggregation pipeline for better performance
      const limitNum = parseInt(limit);
      const pipeline = [
        { $match: filter },
        { $addFields: { sortKey: { $rand: {} } } },
        { $sort: { sortKey: 1 } },
        { $limit: limitNum },
        { $project: { sortKey: 0 } }
      ];
      const restaurants = await Restaurant.aggregate(pipeline);
      return res.json({ success: true, data: restaurants });
    }

    // Default sorting
    if (sort === 'topRated') {
      query = query.sort({ isTopRated: -1, rating: -1 });
    } else {
      query = query.sort({ rating: -1 });
    }

    const restaurants = await query.limit(parseInt(limit));

    res.json({
      success: true,
      data: restaurants
    });
  } catch (error) {
    console.error('Error getting restaurants by category:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Failed to get restaurants by category'
      }
    });
  }
};

module.exports = {
  getHomeData,
  getCategories,
  getOffers,
  getRestaurants,
  getBestSellingFoods,
  getRestaurantsByCategory,
  getFoodsByRestaurant,
  toggleFavoriteRestaurant,
  toggleFavoriteFood,
  getRestaurantDetails
};
