const Category = require('../models/Category');
const Offer = require('../models/Offer');
const Restaurant = require('../models/Restaurant');
const Food = require('../models/Food');
const Review = require('../models/Review');

const seedCategories = async () => {
  try {
    // Ensure base categories exist (upsert)
    const baseCategories = [
      {
        name: 'Food',
        nameAr: 'طعام',
        icon: 'restaurant_menu',
        color: '#FF9800',
        gradient: ['#FF9800', '#FFCC02'],
        order: 1
      },
      {
        name: 'Grocery',
        nameAr: 'بقالة',
        icon: 'local_grocery_store',
        color: '#4CAF50',
        gradient: ['#4CAF50', '#8BC34A'],
        order: 2
      },
      {
        name: 'Markets',
        nameAr: 'أسواق',
        icon: 'store',
        color: '#2196F3',
        gradient: ['#2196F3', '#03DAC6'],
        order: 3
      },
      {
        name: 'Pharmacies',
        nameAr: 'صيدليات',
        icon: 'medical_services',
        color: '#F44336',
        gradient: ['#F44336', '#FF9800'],
        order: 4
      },
      {
        name: 'Gifts',
        nameAr: 'هدايا',
        icon: 'card_giftcard',
        color: '#9C27B0',
        gradient: ['#9C27B0', '#E91E63'],
        order: 5
      },
      {
        name: 'Stores',
        nameAr: 'متاجر',
        icon: 'shopping_bag',
        color: '#FF5722',
        gradient: ['#FF5722', '#FF9800'],
        order: 6
      }
    ];

    // Cuisine categories
    const cuisineCategories = [
      { name: 'Pizza', nameAr: 'بيتزا', icon: 'local_pizza', color: '#E53935', gradient: ['#E53935', '#FF7043'], order: 11 },
      { name: 'Burger', nameAr: 'برجر', icon: 'lunch_dining', color: '#8D6E63', gradient: ['#8D6E63', '#D7CCC8'], order: 12 },
      { name: 'Shawarma', nameAr: 'شاورما', icon: 'kebab_dining', color: '#6D4C41', gradient: ['#6D4C41', '#A1887F'], order: 13 },
      { name: 'Fried Chicken', nameAr: 'دجاج مقلي', icon: 'set_meal', color: '#FFB300', gradient: ['#FFB300', '#FFE082'], order: 14 },
      { name: 'Desserts', nameAr: 'حلويات', icon: 'cake', color: '#EC407A', gradient: ['#EC407A', '#F48FB1'], order: 15 },
      { name: 'Grills', nameAr: 'مشويات', icon: 'outdoor_grill', color: '#5D4037', gradient: ['#5D4037', '#8D6E63'], order: 16 }
    ];

    // Grocery subcategories (to power grocery UI filters)
    const grocerySubcategories = [
      { name: 'Fruits & Vegetables', nameAr: 'فواكه وخضروات', icon: 'nutrition', color: '#43A047', gradient: ['#43A047', '#A5D6A7'], order: 201 },
      { name: 'Dairy & Eggs', nameAr: 'ألبان وبيض', icon: 'egg', color: '#8E24AA', gradient: ['#8E24AA', '#CE93D8'], order: 202 },
      { name: 'Meat & Poultry', nameAr: 'لحوم ودواجن', icon: 'set_meal', color: '#D81B60', gradient: ['#D81B60', '#F06292'], order: 203 },
      { name: 'Bakery', nameAr: 'مخبوزات', icon: 'bakery_dining', color: '#F57C00', gradient: ['#F57C00', '#FFB74D'], order: 204 },
      { name: 'Beverages', nameAr: 'مشروبات', icon: 'local_drink', color: '#1E88E5', gradient: ['#1E88E5', '#90CAF9'], order: 205 },
      { name: 'Snacks', nameAr: 'سناكس', icon: 'cookie', color: '#6D4C41', gradient: ['#6D4C41', '#A1887F'], order: 206 },
    ];

    // Markets subcategories (to power markets UI filters)
    const marketsSubcategories = [
      { name: 'Fresh Produce', nameAr: 'منتجات طازجة', icon: 'eco', color: '#2E7D32', gradient: ['#2E7D32', '#66BB6A'], order: 301 },
      { name: 'Organic Products', nameAr: 'منتجات عضوية', icon: 'spa', color: '#00796B', gradient: ['#00796B', '#26A69A'], order: 302 },
      { name: 'Beverages', nameAr: 'مشروبات', icon: 'local_drink', color: '#1565C0', gradient: ['#1565C0', '#64B5F6'], order: 303 },
      { name: 'Snacks', nameAr: 'سناكس', icon: 'cookie', color: '#4E342E', gradient: ['#4E342E', '#8D6E63'], order: 304 },
      { name: 'Household Items', nameAr: 'منتجات منزلية', icon: 'home', color: '#5E35B1', gradient: ['#5E35B1', '#9575CD'], order: 305 },
    ];

    const ensureCategory = async (c) => {
      await Category.updateOne(
        { name: c.name },
        { $setOnInsert: c },
        { upsert: true }
      );
    };

    for (const c of baseCategories) await ensureCategory(c);
    for (const c of cuisineCategories) await ensureCategory(c);
    for (const c of grocerySubcategories) await ensureCategory(c);
    for (const c of marketsSubcategories) await ensureCategory(c);

    // Pharmacy subcategories (to filter pharmacies section)
    const pharmacySubcategories = [
      { name: 'Medicines', nameAr: 'أدوية', icon: 'local_pharmacy', color: '#1976D2', gradient: ['#1976D2', '#42A5F5'], order: 101 },
      { name: 'Supplements', nameAr: 'مكملات غذائية', icon: 'emergency', color: '#2E7D32', gradient: ['#2E7D32', '#66BB6A'], order: 102 },
      { name: 'Personal Care', nameAr: 'العناية الشخصية', icon: 'face_retouching_natural', color: '#6D4C41', gradient: ['#6D4C41', '#8D6E63'], order: 103 },
      { name: 'Cosmetics', nameAr: 'مستحضرات تجميل', icon: 'brush', color: '#AD1457', gradient: ['#AD1457', '#EC407A'], order: 104 },
      { name: 'Mother & Baby Care', nameAr: 'العناية بالأم والطفل', icon: 'child_care', color: '#F57C00', gradient: ['#F57C00', '#FFB74D'], order: 105 },
      { name: 'Medical Equipment', nameAr: 'الأدوات الطبية', icon: 'health_and_safety', color: '#00796B', gradient: ['#00796B', '#26A69A'], order: 106 },
    ];

    for (const c of pharmacySubcategories) await ensureCategory(c);

    console.log('Categories ensured successfully');
  } catch (error) {
    console.error('Error seeding categories:', error);
  }
};

const seedOffers = async () => {
  try {
    const offersCount = await Offer.countDocuments();
    if (offersCount > 0) {
      console.log('Offers already exist, skipping seed...');
      return;
    }

    const offers = [
      {
        title: 'Today\'s Special',
        titleAr: 'عرض اليوم',
        subtitle: '29% off on all burgers',
        subtitleAr: 'خصم 29% على جميع البرجر',
        color: '#FF6B35',
        icon: '🍔',
        image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        discount: '29',
        discountType: 'percentage',
        endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
        order: 1
      },
      {
        title: 'Free Delivery',
        titleAr: 'توصيل مجاني',
        subtitle: 'Free delivery on orders above 50 SAR',
        subtitleAr: 'توصيل مجاني للطلبات أكثر من 50 ريال',
        color: '#FF6B35',
        icon: '🚚',
        image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        coverImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
        discount: 'FREE',
        discountType: 'free_delivery',
        endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        order: 2
      },
      {
        title: 'Pizza Night',
        titleAr: 'ليلة البيتزا',
        subtitle: '50% off on all pizzas after 8 PM',
        subtitleAr: 'خصم 50% على جميع البيتزا بعد الساعة 8 مساءً',
        color: '#FF6B35',
        icon: '🍕',
        image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
        discount: '50',
        discountType: 'percentage',
        endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        order: 3
      }
    ];

    await Offer.insertMany(offers);
    console.log('Offers seeded successfully');
  } catch (error) {
    console.error('Error seeding offers:', error);
  }
};

const seedRestaurants = async () => {
  try {
    const restaurantsCount = await Restaurant.countDocuments();
    if (restaurantsCount > 0) {
      console.log('Restaurants already exist, skipping initial insert...');
      // do not return; we will still ensure flags below via upserts
    }

    const categories = await Category.find();
    const foodCategory = categories.find(cat => cat.name === 'Food');
    const groceryCat = categories.find(cat => cat.name === 'Grocery');
    const marketsCat = categories.find(cat => cat.name === 'Markets');
    const pizzaCat = categories.find(cat => cat.name === 'Pizza');
    const burgerCat = categories.find(cat => cat.name === 'Burger');
    const shawarmaCat = categories.find(cat => cat.name === 'Shawarma');
    const friedCat = categories.find(cat => cat.name === 'Fried Chicken');
    const dessertsCat = categories.find(cat => cat.name === 'Desserts');
    const grillsCat = categories.find(cat => cat.name === 'Grills');
    // Grocery subcats
    const fruitsVegCat = categories.find(cat => cat.name === 'Fruits & Vegetables');
    const dairyEggsCat = categories.find(cat => cat.name === 'Dairy & Eggs');
    const meatPoultryCat = categories.find(cat => cat.name === 'Meat & Poultry');
    const bakeryCat = categories.find(cat => cat.name === 'Bakery');
    const beveragesGroceryCat = categories.find(cat => cat.name === 'Beverages');
    const snacksGroceryCat = categories.find(cat => cat.name === 'Snacks');
    // Pharmacies and its subcategories
    const pharmaciesCat = categories.find(cat => cat.name === 'Pharmacies');
    const medCat = categories.find(cat => cat.name === 'Medicines');
    const suppCat = categories.find(cat => cat.name === 'Supplements');
    const personalCareCat = categories.find(cat => cat.name === 'Personal Care');
    const cosmeticsCat = categories.find(cat => cat.name === 'Cosmetics');
    const motherBabyCat = categories.find(cat => cat.name === 'Mother & Baby Care');
    const equipmentCat = categories.find(cat => cat.name === 'Medical Equipment');
    // Markets subcats
    const freshProduceCat = categories.find(cat => cat.name === 'Fresh Produce');
    const organicProductsCat = categories.find(cat => cat.name === 'Organic Products');
    const beveragesMarketsCat = categories.find(cat => cat.name === 'Beverages');
    const snacksMarketsCat = categories.find(cat => cat.name === 'Snacks');
    const householdItemsCat = categories.find(cat => cat.name === 'Household Items');

    const baseRestaurants = [
      {
        name: 'Burger House',
        nameAr: 'بيت البرجر',
        description: 'Best burgers in town with fresh ingredients',
        descriptionAr: 'أفضل برجر في المدينة بمكونات طازجة',
        image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        coverImage: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1200',
        rating: 4.5,
        reviewCount: 120,
        deliveryTime: '25-35 دقيقة',
        deliveryFee: 15,
        minimumOrder: 50,
        isTopRated: true,
        isFavorite: true,
        categories: [foodCategory?._id, burgerCat?._id].filter(Boolean),
        address: 'الرياض، حي النخيل',
        phone: '+966501234567'
      },
      {
        name: 'Pizza Palace',
        nameAr: 'قصر البيتزا',
        description: 'Authentic Italian pizzas made fresh daily',
        descriptionAr: 'بيتزا إيطالية أصيلة تُحضر طازجة يومياً',
        image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        rating: 4.7,
        reviewCount: 89,
        deliveryTime: '30-45 دقيقة',
        deliveryFee: 12,
        minimumOrder: 60,
        isTopRated: true,
        categories: [foodCategory?._id, pizzaCat?._id].filter(Boolean),
        address: 'الرياض، حي الملك فهد',
        phone: '+966502345678'
      },
      {
        name: 'Shawarma Corner',
        nameAr: 'ركن الشاورما',
        description: 'Traditional Middle Eastern shawarma',
        descriptionAr: 'شاورما شرق أوسطية تقليدية',
        image: 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=400',
        coverImage: 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=1200',
        rating: 4.3,
        reviewCount: 156,
        deliveryTime: '20-30 دقيقة',
        deliveryFee: 10,
        minimumOrder: 30,
        isFavorite: true,
        categories: [foodCategory?._id, shawarmaCat?._id].filter(Boolean),
        address: 'الرياض، حي العليا',
        phone: '+966503456789'
      }
    ];

    if (restaurantsCount === 0) {
      await Restaurant.insertMany(baseRestaurants);
      console.log('Restaurants seeded successfully');
    }

    // Upsert many restaurants per cuisine to ensure rich category listings
    const ensureRestaurant = async (doc) => {
      await Restaurant.updateOne(
        { name: doc.name },
        { $set: doc, $setOnInsert: { isActive: true, isOpen: true } },
        { upsert: true }
      );
    };

    const mk = (overrides = {}) => ({
      rating: 4 + Math.random() * 1,
      reviewCount: Math.floor(50 + Math.random() * 800),
      deliveryTime: `${20 + Math.floor(Math.random()*25)}- ${30 + Math.floor(Math.random()*30)} دقيقة`,
      deliveryFee: [0, 8, 10, 12, 15][Math.floor(Math.random()*5)],
      minimumOrder: [30, 40, 50, 60, 70][Math.floor(Math.random()*5)],
      isTopRated: Math.random() > 0.6,
      isFavorite: Math.random() > 0.7,
      address: 'الرياض',
      phone: '+9665' + Math.floor(10000000 + Math.random()*89999999),
      ...overrides,
    });

    const pizzaList = [
      mk({ name: 'Napoli Pizza', nameAr: 'بيتزا نابولي', image: 'https://images.unsplash.com/photo-1548365328-9f547fb09542?w=400', categories: [foodCategory?._id, pizzaCat?._id].filter(Boolean) }),
      mk({ name: 'Roma Slice', nameAr: 'شريحة روما', image: 'https://images.unsplash.com/photo-1600628422011-64773ba1c1f2?w=400', categories: [foodCategory?._id, pizzaCat?._id].filter(Boolean) }),
      mk({ name: 'Mamma Mia Pizza', nameAr: 'ماماميا بيتزا', image: 'https://images.unsplash.com/photo-1545048702-79362596cdc9?w=400', categories: [foodCategory?._id, pizzaCat?._id].filter(Boolean) }),
      mk({ name: 'Firewood Pizza', nameAr: 'بيتزا الحطب', image: 'https://images.unsplash.com/photo-1541745537413-b804b0c5091f?w=400', categories: [foodCategory?._id, pizzaCat?._id].filter(Boolean) }),
      mk({ name: 'Cheesy Crust', nameAr: 'قشرة الجبن', image: 'https://images.unsplash.com/photo-1541745537413-1e6a8f6d26d4?w=400', categories: [foodCategory?._id, pizzaCat?._id].filter(Boolean) }),
    ];

    const burgerList = [
      mk({ name: 'Smash Burger Co', nameAr: 'سماش برجر', image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400', categories: [foodCategory?._id, burgerCat?._id].filter(Boolean) }),
      mk({ name: 'Grill & Bun', nameAr: 'الشواية و البان', image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400', categories: [foodCategory?._id, burgerCat?._id].filter(Boolean) }),
      mk({ name: 'Prime Burger', nameAr: 'برايم برجر', image: 'https://images.unsplash.com/photo-1550547660-7f30e2f8f0b3?w=400', categories: [foodCategory?._id, burgerCat?._id].filter(Boolean) }),
      mk({ name: 'Urban Beef', nameAr: 'أوربان بيف', image: 'https://images.unsplash.com/photo-1552632159-1b11f4c1a3b1?w=400', categories: [foodCategory?._id, burgerCat?._id].filter(Boolean) }),
      mk({ name: 'Burger Factory', nameAr: 'مصنع البرجر', image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400', categories: [foodCategory?._id, burgerCat?._id].filter(Boolean) }),
    ];

    // Grocery stores
    const mkGrocery = (overrides = {}) => mk({
      image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      ...overrides,
    });

    const groceryStoresFruitsVeg = [
      mkGrocery({ name: 'Green Basket', nameAr: 'السلة الخضراء', categories: [groceryCat?._id, fruitsVegCat?._id].filter(Boolean) }),
      mkGrocery({ name: 'Fresh Farm', nameAr: 'المزرعة الطازجة', categories: [groceryCat?._id, fruitsVegCat?._id].filter(Boolean) }),
    ];
    const groceryStoresDairyEggs = [
      mkGrocery({ name: 'Dairy Hub', nameAr: 'دايري هب', categories: [groceryCat?._id, dairyEggsCat?._id].filter(Boolean) }),
      mkGrocery({ name: 'Egg & Milk', nameAr: 'بيض وحليب', categories: [groceryCat?._id, dairyEggsCat?._id].filter(Boolean) }),
    ];
    const groceryStoresMeatPoultry = [
      mkGrocery({ name: 'Prime Butchery', nameAr: 'الملحمة المميزة', categories: [groceryCat?._id, meatPoultryCat?._id].filter(Boolean) }),
      mkGrocery({ name: 'Poultry House', nameAr: 'بيت الدواجن', categories: [groceryCat?._id, meatPoultryCat?._id].filter(Boolean) }),
    ];
    const groceryStoresBakery = [
      mkGrocery({ name: 'Daily Bread', nameAr: 'خبز يومي', categories: [groceryCat?._id, bakeryCat?._id].filter(Boolean) }),
      mkGrocery({ name: 'Golden Bakery', nameAr: 'المخبز الذهبي', categories: [groceryCat?._id, bakeryCat?._id].filter(Boolean) }),
    ];
    const groceryStoresBeverages = [
      mkGrocery({ name: 'Beverage Corner', nameAr: 'ركن المشروبات', categories: [groceryCat?._id, beveragesGroceryCat?._id].filter(Boolean) }),
      mkGrocery({ name: 'Drink Station', nameAr: 'محطة المشروبات', categories: [groceryCat?._id, beveragesGroceryCat?._id].filter(Boolean) }),
    ];
    const groceryStoresSnacks = [
      mkGrocery({ name: 'Snack World', nameAr: 'عالم السناكس', categories: [groceryCat?._id, snacksGroceryCat?._id].filter(Boolean) }),
      mkGrocery({ name: 'Crunchy Bites', nameAr: 'لقيمات مقرمشة', categories: [groceryCat?._id, snacksGroceryCat?._id].filter(Boolean) }),
    ];

    const shawarmaList = [
      mk({ name: 'Shawarma Al Sultan', nameAr: 'شاورما السلطان', image: 'https://images.unsplash.com/photo-1615873968403-89e068629265?w=400', categories: [foodCategory?._id, shawarmaCat?._id].filter(Boolean) }),
      mk({ name: 'Damascus Shawarma', nameAr: 'شاورما دمشق', image: 'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?w=400', categories: [foodCategory?._id, shawarmaCat?._id].filter(Boolean) }),
      mk({ name: 'Cedar Shawarma', nameAr: 'سيدر شاورما', image: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400', categories: [foodCategory?._id, shawarmaCat?._id].filter(Boolean) }),
      mk({ name: 'Shawarma Express', nameAr: 'شاورما اكسبرس', image: 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=400', categories: [foodCategory?._id, shawarmaCat?._id].filter(Boolean) }),
    ];

    const friedList = [
      mk({ name: 'Crispy Chicken', nameAr: 'دجاج مقرمش', image: 'https://images.unsplash.com/photo-1604908176997-4312f9b1b175?w=400', categories: [foodCategory?._id, friedCat?._id].filter(Boolean) }),
      mk({ name: 'Golden Fried', nameAr: 'المقلي الذهبي', image: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400', categories: [foodCategory?._id, friedCat?._id].filter(Boolean) }),
      mk({ name: 'Wing Box', nameAr: 'وينج بوكس', image: 'https://images.unsplash.com/photo-1606756790138-261d2b21cd87?w=400', categories: [foodCategory?._id, friedCat?._id].filter(Boolean) }),
    ];

    const dessertsList = [
      mk({ name: 'Sweet Heaven', nameAr: 'سويت هيفن', image: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400', categories: [dessertsCat?._id].filter(Boolean) }),
      mk({ name: 'Sugar & Cream', nameAr: 'سكر وكريمة', image: 'https://images.unsplash.com/photo-1551024709-8f23befc6cf7?w=400', categories: [dessertsCat?._id].filter(Boolean) }),
      mk({ name: 'Joy Desserts', nameAr: 'جوي ديسيرتس', image: 'https://images.unsplash.com/photo-1519861531473-9200262188bf?w=400', categories: [dessertsCat?._id].filter(Boolean) }),
    ];

    const grillsList = [
      mk({ name: 'Kabob Palace', nameAr: 'قصر الكباب', image: 'https://images.unsplash.com/photo-1562158070-2f9b5b4b5390?w=400', categories: [grillsCat?._id].filter(Boolean) }),
      mk({ name: 'Grill Master', nameAr: 'جرل ماستر', image: 'https://images.unsplash.com/photo-1555992336-03a23c43a3d1?w=400', categories: [grillsCat?._id].filter(Boolean) }),
      mk({ name: 'Al Mashawi', nameAr: 'المشاوي', image: 'https://images.unsplash.com/photo-1625944526686-3a9e3ebc2c86?w=400', categories: [grillsCat?._id].filter(Boolean) }),
      mk({ name: 'Charcoal House', nameAr: 'بيت الفحم', image: 'https://images.unsplash.com/photo-1550547660-7a9b6c0f6f3d?w=400', categories: [grillsCat?._id].filter(Boolean) }),
    ];

    // Pharmacies list seeded similar to restaurants but tagged with Pharmacies + subcategory
    const mkPharmacy = (overrides = {}) => mk({
      description: 'صيدلية تقدم خدمات طبية وتوصيل سريع',
      descriptionAr: 'صيدلية تقدم خدمات طبية وتوصيل سريع',
      image: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=400',
      ...overrides,
    });

    const pharmaciesMedicines = [
      mkPharmacy({ name: 'Al Amal Pharmacy', nameAr: 'صيدلية الأمل', categories: [pharmaciesCat?._id, medCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Health Plus Pharmacy', nameAr: 'صيدلية الصحة بلس', categories: [pharmaciesCat?._id, medCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'City Care Pharmacy', nameAr: 'صيدلية سيتي كير', categories: [pharmaciesCat?._id, medCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Green Cross Pharmacy', nameAr: 'الصليب الأخضر', categories: [pharmaciesCat?._id, medCat?._id].filter(Boolean) }),
    ];
    const pharmaciesSupplements = [
      mkPharmacy({ name: 'Vita Care Pharmacy', nameAr: 'صيدلية فيتا كير', categories: [pharmaciesCat?._id, suppCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Nutri Pharma', nameAr: 'نيوتري فارما', categories: [pharmaciesCat?._id, suppCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Power Nutrition', nameAr: 'باور نيوترشن', categories: [pharmaciesCat?._id, suppCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Muscle Labs', nameAr: 'ماسكل لابس', categories: [pharmaciesCat?._id, suppCat?._id].filter(Boolean) }),
    ];
    const pharmaciesPersonalCare = [
      mkPharmacy({ name: 'Pure Care Pharmacy', nameAr: 'صيدلية بيور كير', categories: [pharmaciesCat?._id, personalCareCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Soft Touch Pharmacy', nameAr: 'صيدلية سوفت تتش', categories: [pharmaciesCat?._id, personalCareCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Gentle Care', nameAr: 'جنتل كير', categories: [pharmaciesCat?._id, personalCareCat?._id].filter(Boolean) }),
    ];
    const pharmaciesCosmetics = [
      mkPharmacy({ name: 'Beauty Pharma', nameAr: 'بيوتي فارما', categories: [pharmaciesCat?._id, cosmeticsCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Glam Store', nameAr: 'غلام ستور', categories: [pharmaciesCat?._id, cosmeticsCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Aura Beauty', nameAr: 'أورا بيوتي', categories: [pharmaciesCat?._id, cosmeticsCat?._id].filter(Boolean) }),
    ];
    const pharmaciesMotherBaby = [
      mkPharmacy({ name: 'Family Care Pharmacy', nameAr: 'صيدلية عناية العائلة', categories: [pharmaciesCat?._id, motherBabyCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Mama & Me', nameAr: 'ماما آند مي', categories: [pharmaciesCat?._id, motherBabyCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Baby First', nameAr: 'بيبي فيرست', categories: [pharmaciesCat?._id, motherBabyCat?._id].filter(Boolean) }),
    ];
    const pharmaciesEquipment = [
      mkPharmacy({ name: 'MedEquip Pharmacy', nameAr: 'صيدلية ميد إكويب', categories: [pharmaciesCat?._id, equipmentCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'Care Devices', nameAr: 'كير ديفايسز', categories: [pharmaciesCat?._id, equipmentCat?._id].filter(Boolean) }),
      mkPharmacy({ name: 'HealthTech Supplies', nameAr: 'هيلث تك سبلايز', categories: [pharmaciesCat?._id, equipmentCat?._id].filter(Boolean) }),
    ];

    // Markets stores
    const mkMarket = (overrides = {}) => mk({
      image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
      ...overrides,
    });
    const marketsFreshProduce = [
      mkMarket({ name: 'Daily Market', nameAr: 'ماركت يومي', categories: [marketsCat?._id, freshProduceCat?._id].filter(Boolean) }),
      mkMarket({ name: 'Farmers Market', nameAr: 'سوق المزارعين', categories: [marketsCat?._id, freshProduceCat?._id].filter(Boolean) }),
    ];
    const marketsOrganic = [
      mkMarket({ name: 'Organic Haven', nameAr: 'العضوي', categories: [marketsCat?._id, organicProductsCat?._id].filter(Boolean) }),
      mkMarket({ name: 'Pure Organics', nameAr: 'بيور أورجانيكس', categories: [marketsCat?._id, organicProductsCat?._id].filter(Boolean) }),
    ];
    const marketsBeverages = [
      mkMarket({ name: 'Drink Depot', nameAr: 'ديبوت المشروبات', categories: [marketsCat?._id, beveragesMarketsCat?._id].filter(Boolean) }),
    ];
    const marketsSnacks = [
      mkMarket({ name: 'Snack Stop', nameAr: 'وقف السناكس', categories: [marketsCat?._id, snacksMarketsCat?._id].filter(Boolean) }),
    ];
    const marketsHousehold = [
      mkMarket({ name: 'Home Essentials', nameAr: 'أساسيات المنزل', categories: [marketsCat?._id, householdItemsCat?._id].filter(Boolean) }),
    ];

    const allLists = [
      pizzaList, burgerList, shawarmaList, friedList, dessertsList, grillsList,
      // Grocery
      groceryStoresFruitsVeg, groceryStoresDairyEggs, groceryStoresMeatPoultry, groceryStoresBakery, groceryStoresBeverages, groceryStoresSnacks,
      // Pharmacies
      pharmaciesMedicines, pharmaciesSupplements, pharmaciesPersonalCare, pharmaciesCosmetics, pharmaciesMotherBaby, pharmaciesEquipment,
      // Markets
      marketsFreshProduce, marketsOrganic, marketsBeverages, marketsSnacks, marketsHousehold,
    ];
    for (const list of allLists) {
      for (const r of list) {
        await ensureRestaurant(r);
      }
    }
    // Ensure flags for favorites and top rated even if docs already existed
    await Restaurant.updateOne({ name: 'Burger House' }, { $set: { isFavorite: true, isTopRated: true } }, { upsert: false });
    await Restaurant.updateOne({ name: 'Pizza Palace' }, { $set: { isTopRated: true } }, { upsert: false });
    await Restaurant.updateOne({ name: 'Shawarma Corner' }, { $set: { isFavorite: true } }, { upsert: false });
    console.log('Restaurant flags ensured (favorites/top rated)');
  } catch (error) {
    console.error('Error seeding restaurants:', error);
  }
};

const seedFoods = async () => {
  try {
    const foodsCount = await Food.countDocuments();
    if (foodsCount > 0) {
      console.log('Foods already exist, skipping initial insert...');
      // do not return; we will still ensure flags below via updates
    }

    const restaurants = await Restaurant.find();
    const categories = await Category.find();
    const foodCategory = categories.find(cat => cat.name === 'Food');
    const pharmaciesCat = categories.find(cat => cat.name === 'Pharmacies');
    const medCat = categories.find(cat => cat.name === 'Medicines');
    const suppCat = categories.find(cat => cat.name === 'Supplements');
    const personalCareCat = categories.find(cat => cat.name === 'Personal Care');
    const cosmeticsCat = categories.find(cat => cat.name === 'Cosmetics');
    const motherBabyCat = categories.find(cat => cat.name === 'Mother & Baby Care');
    const equipmentCat = categories.find(cat => cat.name === 'Medical Equipment');
    // Grocery root + subcats
    const groceryRoot = categories.find(cat => cat.name === 'Grocery');
    const grocerySubcats = {
      fruitsVeg: categories.find(cat => cat.name === 'Fruits & Vegetables'),
      dairyEggs: categories.find(cat => cat.name === 'Dairy & Eggs'),
      meatPoultry: categories.find(cat => cat.name === 'Meat & Poultry'),
      bakery: categories.find(cat => cat.name === 'Bakery'),
      beverages: categories.find(cat => cat.name === 'Beverages'),
      snacks: categories.find(cat => cat.name === 'Snacks'),
    };
    // Markets root + subcats
    const marketsRoot = categories.find(cat => cat.name === 'Markets');
    const marketsSubcats = {
      freshProduce: categories.find(cat => cat.name === 'Fresh Produce'),
      organicProducts: categories.find(cat => cat.name === 'Organic Products'),
      beverages: categories.find(cat => cat.name === 'Beverages'),
      snacks: categories.find(cat => cat.name === 'Snacks'),
      household: categories.find(cat => cat.name === 'Household Items'),
    };

    const foods = [
      {
        name: 'Classic Burger',
        nameAr: 'برجر كلاسيكي',
        description: 'Juicy beef patty with lettuce, tomato, and cheese',
        descriptionAr: 'قطعة لحم عصيرة مع الخس والطماطم والجبن',
        image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        price: 35,
        originalPrice: 45,
        rating: 4.6,
        reviewCount: 45,
        preparationTime: '15-20 دقيقة',
        isBestSelling: true,
        restaurant: restaurants[0]._id,
        category: foodCategory._id,
        ingredients: ['Beef patty', 'Lettuce', 'Tomato', 'Cheese', 'Bun'],
        tags: ['Popular', 'Best Seller']
      },
      {
        name: 'Margherita Pizza',
        nameAr: 'بيتزا مارغريتا',
        description: 'Classic Italian pizza with fresh mozzarella and basil',
        descriptionAr: 'بيتزا إيطالية كلاسيكية مع جبن الموزاريلا الطازج والريحان',
        image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
        price: 42,
        rating: 4.8,
        reviewCount: 32,
        preparationTime: '20-25 دقيقة',
        isBestSelling: true,
        restaurant: restaurants[1]._id,
        category: foodCategory._id,
        ingredients: ['Pizza dough', 'Mozzarella', 'Basil', 'Tomato sauce'],
        tags: ['Vegetarian', 'Classic']
      },
      {
        name: 'Chicken Shawarma',
        nameAr: 'شاورما دجاج',
        description: 'Tender chicken shawarma with garlic sauce',
        descriptionAr: 'شاورما دجاج طرية مع صلصة الثوم',
        image: 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=400',
        price: 25,
        rating: 4.4,
        reviewCount: 67,
        preparationTime: '10-15 دقيقة',
        isBestSelling: true,
        isPopular: true,
        restaurant: restaurants[2]._id,
        category: foodCategory._id,
        ingredients: ['Chicken', 'Pita bread', 'Garlic sauce', 'Vegetables'],
        tags: ['Traditional', 'Fast']
      }
    ];

    if (foodsCount === 0) {
      await Food.insertMany(foods);
      console.log('Foods seeded successfully');
    }

    // Helper to upsert a food by name for a restaurant
    const ensureFood = async (doc) => {
      await Food.updateOne(
        { name: doc.name, restaurant: doc.restaurant },
        { $set: doc },
        { upsert: true }
      );
    };

    // Generate a handful of foods per restaurant
    const makeFood = (overrides = {}) => ({
      price: [18, 22, 28, 32, 38, 45][Math.floor(Math.random()*6)],
      originalPrice: null,
      rating: (4 + Math.random()).toFixed(1),
      reviewCount: Math.floor(10 + Math.random()*300),
      preparationTime: `${10 + Math.floor(Math.random()*20)}- ${20 + Math.floor(Math.random()*25)} دقيقة`,
      isAvailable: true,
      isPopular: Math.random() > 0.6,
      isBestSelling: Math.random() > 0.7,
      ingredients: [],
      allergens: [],
      tags: [],
      ...overrides,
    });

    for (const r of restaurants) {
      const baseName = r.name;
      const rId = r._id;
      const isPharmacy = Array.isArray(r.categories) && pharmaciesCat && r.categories.some(c => String(c) === String(pharmaciesCat._id));
      const isGrocery = Array.isArray(r.categories) && groceryRoot && r.categories.some(c => String(c) === String(groceryRoot._id));
      const isMarkets = Array.isArray(r.categories) && marketsRoot && r.categories.some(c => String(c) === String(marketsRoot._id));

      if (isPharmacy) {
        // Pharmacy products: assign category to one of pharmacy subcategories that the pharmacy belongs to
        const pharmaSubcats = [medCat, suppCat, personalCareCat, cosmeticsCat, motherBabyCat, equipmentCat].filter(Boolean);
        const ownedSubcats = pharmaSubcats.filter(cat => r.categories.some(c => String(c) === String(cat._id)));
        const pickCat = (ownedSubcats[0] || medCat || suppCat || personalCareCat || cosmeticsCat || motherBabyCat || equipmentCat)?._id;
        const common = { restaurant: rId, category: pickCat };
        const items = [
          makeFood({ name: `${baseName} Paracetamol 500mg`, nameAr: `${r.nameAr ?? baseName} باراسيتامول 500mg`, image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400', price: 15, ...common, tags: ['medicines'] }),
          makeFood({ name: `${baseName} Vitamin C`, nameAr: `${r.nameAr ?? baseName} فيتامين C`, image: 'https://images.unsplash.com/photo-1618354691373-d851c5c3cf49?w=400', price: 30, ...common, tags: ['supplements'] }),
          makeFood({ name: `${baseName} Baby Diapers`, nameAr: `${r.nameAr ?? baseName} حفاضات أطفال`, image: 'https://images.unsplash.com/photo-1624843092051-8cc6a3be8af0?w=400', price: 50, ...common, tags: ['mother-baby'] }),
          makeFood({ name: `${baseName} Skin Cleanser`, nameAr: `${r.nameAr ?? baseName} منظف بشرة`, image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400', price: 45, ...common, tags: ['personal-care'] }),
        ];
        for (const f of items) await ensureFood(f);
      } else if (isGrocery) {
        // Grocery products: pick one of the grocery subcategories the store belongs to
        const gOwned = [grocerySubcats.fruitsVeg, grocerySubcats.dairyEggs, grocerySubcats.meatPoultry, grocerySubcats.bakery, grocerySubcats.beverages, grocerySubcats.snacks]
          .filter(Boolean)
          .filter(cat => r.categories.some(c => String(c) === String(cat._id)));
        const pickCat = (gOwned[0] || grocerySubcats.fruitsVeg || grocerySubcats.dairyEggs || grocerySubcats.meatPoultry || grocerySubcats.bakery || grocerySubcats.beverages || grocerySubcats.snacks)?._id;
        const common = { restaurant: rId, category: pickCat };
        const items = [
          makeFood({ name: `${baseName} Apples 1kg`, nameAr: `${r.nameAr ?? baseName} تفاح 1كجم`, image: 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400', price: 12, ...common, tags: ['fruits'] }),
          makeFood({ name: `${baseName} Fresh Milk 1L`, nameAr: `${r.nameAr ?? baseName} حليب طازج 1 لتر`, image: 'https://images.unsplash.com/photo-1550581190-9c1c48d21d6c?w=400', price: 9, ...common, tags: ['dairy'] }),
          makeFood({ name: `${baseName} Brown Bread`, nameAr: `${r.nameAr ?? baseName} خبز بني`, image: 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400', price: 7, ...common, tags: ['bakery'] }),
          makeFood({ name: `${baseName} Orange Juice 1L`, nameAr: `${r.nameAr ?? baseName} عصير برتقال 1 لتر`, image: 'https://images.unsplash.com/photo-1571070243306-30c8a3cfa4b6?w=400', price: 10, ...common, tags: ['beverages'] }),
          makeFood({ name: `${baseName} Chips Family Pack`, nameAr: `${r.nameAr ?? baseName} شيبس عائلي`, image: 'https://images.unsplash.com/photo-1604908177224-6efc0fb4bcb2?w=400', price: 8, ...common, tags: ['snacks'] }),
        ];
        for (const f of items) await ensureFood(f);
      } else if (isMarkets) {
        // Markets products: pick one of the markets subcategories the store belongs to
        const mOwned = [marketsSubcats.freshProduce, marketsSubcats.organicProducts, marketsSubcats.beverages, marketsSubcats.snacks, marketsSubcats.household]
          .filter(Boolean)
          .filter(cat => r.categories.some(c => String(c) === String(cat._id)));
        const pickCat = (mOwned[0] || marketsSubcats.freshProduce || marketsSubcats.organicProducts || marketsSubcats.beverages || marketsSubcats.snacks || marketsSubcats.household)?._id;
        const common = { restaurant: rId, category: pickCat };
        const items = [
          makeFood({ name: `${baseName} Organic Tomatoes 1kg`, nameAr: `${r.nameAr ?? baseName} طماطم عضوية 1كجم`, image: 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400', price: 14, ...common, tags: ['fresh-produce'] }),
          makeFood({ name: `${baseName} Eco Dish Soap`, nameAr: `${r.nameAr ?? baseName} سائل جلي صديق للبيئة`, image: 'https://images.unsplash.com/photo-1601460011310-30c9b82a90b9?w=400', price: 18, ...common, tags: ['household'] }),
          makeFood({ name: `${baseName} Sparkling Water 6x`, nameAr: `${r.nameAr ?? baseName} مياه غازية 6 عبوات`, image: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400', price: 16, ...common, tags: ['beverages'] }),
          makeFood({ name: `${baseName} Mixed Nuts 250g`, nameAr: `${r.nameAr ?? baseName} مكسرات مشكلة 250جم`, image: 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400', price: 22, ...common, tags: ['snacks'] }),
        ];
        for (const f of items) await ensureFood(f);
      } else {
        // Regular restaurant foods (Food root): seed 3-4 items per tab via tags
        const common = { restaurant: rId, category: foodCategory?._id };

        const soupItems = [
          makeFood({ name: `${baseName} Tomato Soup`, nameAr: `${r.nameAr ?? baseName} شوربة طماطم`, image: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400', price: 25, ...common, tags: ['soup'] }),
          makeFood({ name: `${baseName} Chicken Soup`, nameAr: `${r.nameAr ?? baseName} شوربة دجاج`, image: 'https://images.unsplash.com/photo-1516100882582-96c3a05fe590?w=400', price: 28, ...common, tags: ['soup'] }),
          makeFood({ name: `${baseName} Mushroom Cream Soup`, nameAr: `${r.nameAr ?? baseName} شوربة كريمة الفطر`, image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400', price: 30, ...common, tags: ['soup'] }),
        ];

        const appItems = [
          makeFood({ name: `${baseName} Spring Rolls`, nameAr: `${r.nameAr ?? baseName} سبرنج رولز`, image: 'https://images.unsplash.com/photo-1526318472351-c75fcf070305?w=400', price: 32, ...common, tags: ['appetizers'] }),
          makeFood({ name: `${baseName} Garlic Bread`, nameAr: `${r.nameAr ?? baseName} خبز بالثوم`, image: 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400', price: 20, ...common, tags: ['appetizers'] }),
          makeFood({ name: `${baseName} Fried Calamari`, nameAr: `${r.nameAr ?? baseName} حلقات كالماري`, image: 'https://images.unsplash.com/photo-1604908176997-4312f9b1b175?w=400', price: 45, ...common, tags: ['appetizers'] }),
        ];

        const pastaItems = [
          makeFood({ name: `${baseName} Alfredo Pasta`, nameAr: `${r.nameAr ?? baseName} مكرونة ألفريدو`, image: 'https://images.unsplash.com/photo-1523986371872-9d3ba2e2f642?w=400', price: 55, ...common, tags: ['pasta'] }),
          makeFood({ name: `${baseName} Arrabbiata Pasta`, nameAr: `${r.nameAr ?? baseName} مكرونة أرابياتا`, image: 'https://images.unsplash.com/photo-1481931715705-36f3f9a2d626?w=400', price: 48, ...common, tags: ['pasta'] }),
          makeFood({ name: `${baseName} Bolognese Pasta`, nameAr: `${r.nameAr ?? baseName} مكرونة بولونيز`, image: 'https://images.unsplash.com/photo-1543352632-5a1d6f2c6f58?w=400', price: 52, ...common, tags: ['pasta'] }),
        ];

        const drinkItems = [
          makeFood({ name: `${baseName} Lemonade`, nameAr: `${r.nameAr ?? baseName} ليمونادة`, image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', price: 18, ...common, tags: ['drinks'] }),
          makeFood({ name: `${baseName} Iced Tea`, nameAr: `${r.nameAr ?? baseName} شاي مثلج`, image: 'https://images.unsplash.com/photo-1527169402691-feff5539e52c?w=400', price: 16, ...common, tags: ['drinks'] }),
          makeFood({ name: `${baseName} Orange Juice`, nameAr: `${r.nameAr ?? baseName} عصير برتقال`, image: 'https://images.unsplash.com/photo-1542444459-db63c7c0d8e9?w=400', price: 20, ...common, tags: ['drinks'] }),
        ];

        const trending = [
          makeFood({ name: `${baseName} Special 1`, nameAr: `${r.nameAr ?? baseName} خاص 1`, image: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400', price: 40, ...common, isPopular: true }),
          makeFood({ name: `${baseName} Special 2`, nameAr: `${r.nameAr ?? baseName} خاص 2`, image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400', price: 45, ...common, isBestSelling: true }),
        ];

        const general = [
          makeFood({ name: `${baseName} Combo`, nameAr: `${r.nameAr ?? baseName} كومبو`, image: 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?w=400', price: 60, ...common }),
          makeFood({ name: `${baseName} Classic`, nameAr: `${r.nameAr ?? baseName} كلاسيك`, image: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400', price: 35, ...common }),
        ];

        const items = [
          ...soupItems,
          ...appItems,
          ...pastaItems,
          ...drinkItems,
          ...trending,
          ...general,
        ];
        for (const f of items) await ensureFood(f);
      }
    }
    // Ensure best-selling flags on a few foods by name in case docs pre-exist
    await Food.updateOne({ name: 'Classic Burger' }, { $set: { isBestSelling: true } }, { upsert: false });
    await Food.updateOne({ name: 'Margherita Pizza' }, { $set: { isBestSelling: true } }, { upsert: false });
    await Food.updateOne({ name: 'Chicken Shawarma' }, { $set: { isBestSelling: true, isPopular: true } }, { upsert: false });
    console.log('Food flags ensured (best selling/popular)');
  } catch (error) {
    console.error('Error seeding foods:', error);
  }
};

const seedReviews = async () => {
  try {
    const count = await Review.countDocuments();
    if (count > 0) return; // don't spam if already seeded
    const foods = await Food.find().limit(3).select('_id restaurant name').lean();
    const restaurants = await Restaurant.find().limit(3).select('_id name').lean();
    const docs = [];
    for (const f of foods) {
      docs.push({ foodId: f._id, rating: 5, comment: `Amazing ${f.name}!`, userName: 'Ali' });
      docs.push({ foodId: f._id, rating: 4, comment: 'Very good taste', userName: 'Sara' });
    }
    for (const r of restaurants) {
      docs.push({ restaurantId: r._id, rating: 5, comment: `Great place: ${r.name}`, userName: 'Hassan' });
    }
    if (docs.length) await Review.insertMany(docs);
    console.log('Reviews seeded successfully');
  } catch (e) {
    console.error('Error seeding reviews:', e);
  }
};

const seedAllData = async () => {
  console.log('Starting data seeding...');
  await seedCategories();
  await seedOffers();
  await seedRestaurants();
  await seedFoods();
  await seedReviews();
  console.log('Data seeding completed!');
};

module.exports = {
  seedAllData,
  seedCategories,
  seedOffers,
  seedRestaurants,
  seedFoods,
  seedReviews
};
