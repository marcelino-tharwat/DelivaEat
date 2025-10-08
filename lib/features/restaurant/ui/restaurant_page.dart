import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({super.key});

  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  // هذا الموديل لا يؤثر على التصميم
  final RestaurantModel restaurant = RestaurantModel(
    id: 'static_id',
    name: 'DelivaEat Restaurant',
    nameAr: 'مطعم ديليفا إيت',
    description: 'A delicious restaurant serving various cuisines',
    descriptionAr: 'مطعم لذيذ يقدم مجموعة متنوعة من المأكلات',
    image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
    coverImage:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    rating: 4.5,
    reviewCount: 100,
    deliveryTime: '30-45 min',
    deliveryFee: 5.0,
    minimumOrder: 20.0,
    isOpen: true,
    isActive: true,
    isFavorite: false,
    isTopRated: true,
    address: '123 Main St',
    phone: '+1234567890',
  );

  String selectedCategory = 'Trending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // غيرنا لون خلفية السكافولد ليتناسب مع لون الصورة العلوي
      backgroundColor: const Color(0xff1c1c1c),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // --- الجزء الأول: الهيدر (صورة + لوجو) ---
          // هذا الـ Stack يحتوي على الصورة واللوجو والعروض
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // الخلفية
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // اللوجو
              Positioned(
                top: 100,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        '木',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'MANDARIN\nOAK',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'TALES FROM THE WOK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ العروض (نص فوق الصورة ونص فوق الكونتينر)
              Positioned(
                top: 260, // يخلي الكونتينر يبدأ بعد الصورة
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tabs + قائمة الأكل زي ما هي
                      const SizedBox(height: 60), // 👈 مساحة للعروض فوق
                    ],
                  ),
                ),
              ),

              // ✅ العروض (فوق الصورة وجزء منها فوق الكونتينر)
              Positioned(
                top: 230, // بين الصورة والكونتينر الأبيض
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_offer,
                                color: Colors.pink,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '15% off full menu, Min spend 49',
                                  style: TextStyle(
                                    color: Colors.pink.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_offer,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Free delivery on orders above 99',
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(top: 20),

            // **هذا هو التغيير الرئيسي**
            decoration: BoxDecoration(
              color: Colors.white, // لون خلفية المحتوى
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شريط التصنيفات (Category Tabs)
                Container(
                  // padding: const EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    // border: BorderRadius.all(radiusius: Radius.circular(8))
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const Icon(Icons.menu, size: 24),
                      const SizedBox(width: 20),
                      _buildCategoryTab('Trending'),
                      _buildCategoryTab('free'),
                      _buildCategoryTab('Soup'),
                      _buildCategoryTab('Appetizers'),
                      _buildCategoryTab('Pasta'),
                      _buildCategoryTab('Drinks'),
                    ],
                  ),
                ),

                // قائمة الطعام (Food Items)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCategory,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFoodItem(
                        'Chicken Schezwan Fried Rice',
                        'Golden fried Chicken pieces wok-tossed with hotand spicy schezwan fried rice with vegetables like green',
                        'EGP 30',
                        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                      ),
                      const SizedBox(height: 16),
                      _buildFoodItem(
                        'Chicken Schezwan Fried Rice',
                        'Golden fried Chicken pieces wok-tossed with hotand spicy schezwan fried rice with vegetables like green',
                        'EGP 30',
                        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                      ),
                      const SizedBox(height: 16),
                      _buildFoodItem(
                        'Chicken Schezwan Fried Rice',
                        'Golden fried Chicken pieces wok-tossed with hotand spicy schezwan fried rice with vegetables like green',
                        'EGP 30',
                        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                      ),
                      const SizedBox(height: 16),
                      _buildFoodItem(
                        'Chicken Schezwan Fried Rice',
                        'Golden fried Chicken pieces wok-tossed with hotand spicy schezwan fried rice with vegetables like green',
                        'EGP 30',
                        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                      ),
                      const SizedBox(height: 16),
                      _buildFoodItem(
                        'Chicken Schezwan Fried Rice',
                        'Golden fried Chicken pieces wok-tossed with hotand spicy schezwan fried rice with vegetables like green',
                        'EGP 30',
                        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // الدوال المساعدة لم تتغير
  Widget _buildCategoryTab(String title) {
    final isSelected = title == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.orange.shade800 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodItem(
    String title,
    String description,
    String price,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      price,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.restaurant),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
