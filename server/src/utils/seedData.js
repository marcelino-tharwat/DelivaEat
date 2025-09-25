const Category = require('../models/Category');
const Offer = require('../models/Offer');
const Restaurant = require('../models/Restaurant');
const Food = require('../models/Food');

const seedCategories = async () => {
  try {
    const categoriesCount = await Category.countDocuments();
    if (categoriesCount > 0) {
      console.log('Categories already exist, skipping seed...');
      return;
    }

    const categories = [
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

    await Category.insertMany(categories);
    console.log('Categories seeded successfully');
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

    const restaurants = [
      {
        name: 'Burger House',
        nameAr: 'بيت البرجر',
        description: 'Best burgers in town with fresh ingredients',
        descriptionAr: 'أفضل برجر في المدينة بمكونات طازجة',
        image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        rating: 4.5,
        reviewCount: 120,
        deliveryTime: '25-35 دقيقة',
        deliveryFee: 15,
        minimumOrder: 50,
        isTopRated: true,
        isFavorite: true,
        categories: [foodCategory._id],
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
        categories: [foodCategory._id],
        address: 'الرياض، حي الملك فهد',
        phone: '+966502345678'
      },
      {
        name: 'Shawarma Corner',
        nameAr: 'ركن الشاورما',
        description: 'Traditional Middle Eastern shawarma',
        descriptionAr: 'شاورما شرق أوسطية تقليدية',
        image: 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=400',
        rating: 4.3,
        reviewCount: 156,
        deliveryTime: '20-30 دقيقة',
        deliveryFee: 10,
        minimumOrder: 30,
        isFavorite: true,
        categories: [foodCategory._id],
        address: 'الرياض، حي العليا',
        phone: '+966503456789'
      }
    ];

    if (restaurantsCount === 0) {
      await Restaurant.insertMany(restaurants);
      console.log('Restaurants seeded successfully');
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
    // Ensure best-selling flags on a few foods by name in case docs pre-exist
    await Food.updateOne({ name: 'Classic Burger' }, { $set: { isBestSelling: true } }, { upsert: false });
    await Food.updateOne({ name: 'Margherita Pizza' }, { $set: { isBestSelling: true } }, { upsert: false });
    await Food.updateOne({ name: 'Chicken Shawarma' }, { $set: { isBestSelling: true, isPopular: true } }, { upsert: false });
    console.log('Food flags ensured (best selling/popular)');
  } catch (error) {
    console.error('Error seeding foods:', error);
  }
};

const seedAllData = async () => {
  console.log('Starting data seeding...');
  await seedCategories();
  await seedOffers();
  await seedRestaurants();
  await seedFoods();
  console.log('Data seeding completed!');
};

module.exports = {
  seedAllData,
  seedCategories,
  seedOffers,
  seedRestaurants,
  seedFoods
};
