import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/core/widgets/mobile_only_layout.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({super.key});

  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

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

  late final ScrollController _scrollController;
  late List<String> _categories;
  final Map<String, GlobalKey> _categoryKeys = {};
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _categories = [
      l10n.categoryTrending,
      l10n.categoryFree,
      l10n.categorySoup,
      l10n.categoryAppetizers,
      l10n.categoryPasta,
      l10n.categoryDrinks,
    ];
    selectedCategory = _categories.first;
    for (final category in _categories) {
      _categoryKeys[category] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      // غيرنا لون خلفية السكافولد ليتناسب مع لون الصورة العلوي
      backgroundColor: const Color(0xff1c1c1c),
      body: MobileOnlyLayout(
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          children: [
            // --- الجزء الأول: الهيدر (صورة + لوجو) ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // الخلفية
                Container(
                  height: 280.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: 50.h,
                  left: 16.w,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 50.h,
                  right: 16.w,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
                // اللوجو
                Positioned(
                  top: 90.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '木',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: Colors.white, fontSize: 16.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          l10n.restaurantName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white, height: 1),
                        ),
                        // SizedBox(height: 2.h),
                        Text(
                          l10n.restaurantTagline,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ العروض (نص فوق الصورة ونص فوق الكونتينر)
                Positioned(
                  top: 260.h, // يخلي الكونتينر يبدأ بعد الصورة
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tabs + قائمة الأكل زي ما هي
                        SizedBox(height: 60.h), // 👈 مساحة للعروض فوق
                      ],
                    ),
                  ),
                ),

                // ✅ العروض (فوق الصورة وجزء منها فوق الكونتينر)
                Positioned(
                  top: 230.h, // بين الصورة والكونتينر الأبيض
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Color(0xffFEF5F8),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: Colors.pink,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    l10n.offerDiscount15,
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryYellow,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: Colors.pink,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    l10n.offerFreeDelivery99,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
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
              margin: EdgeInsets.only(top: 20.h),

              // **هذا هو التغيير الرئيسي**
              decoration: BoxDecoration(
                color: Colors.white, // لون خلفية المحتوى
                boxShadow: [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شريط التصنيفات (Category Tabs)
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        children: [
                          Icon(Icons.menu, size: 24.sp),
                          ..._categories
                              .map((category) => _buildCategoryTab(category))
                              .toList(),
                        ],
                      ),
                    ),
                  ),

                  // قائمة الطعام (Food Items) - Sections for each category
                  Column(
                    children: _categories.map((category) {
                      return Container(
                        key: _categoryKeys[category],
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 16.h),
                            _buildFoodItem(
                              l10n.foodChickenSchezwanFriedRice,
                              l10n.foodChickenSchezwanFriedRiceDesc,
                              l10n.foodChickenSchezwanFriedRicePrice,
                              'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                            ),
                            SizedBox(height: 16.h),
                            _buildFoodItem(
                              l10n.foodChickenSchezwanFriedRice,
                              l10n.foodChickenSchezwanFriedRiceDesc,
                              l10n.foodChickenSchezwanFriedRicePrice,
                              'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                            ),
                            SizedBox(height: 16.h),
                            _buildFoodItem(
                              l10n.foodChickenSchezwanFriedRice,
                              l10n.foodChickenSchezwanFriedRiceDesc,
                              l10n.foodChickenSchezwanFriedRicePrice,
                              'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                            ),
                            SizedBox(height: 16.h),
                            _buildFoodItem(
                              l10n.foodChickenSchezwanFriedRice,
                              l10n.foodChickenSchezwanFriedRiceDesc,
                              l10n.foodChickenSchezwanFriedRicePrice,
                              'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                            ),
                            SizedBox(height: 16.h),
                            _buildFoodItem(
                              l10n.foodChickenSchezwanFriedRice,
                              l10n.foodChickenSchezwanFriedRiceDesc,
                              l10n.foodChickenSchezwanFriedRicePrice,
                              'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        Scrollable.ensureVisible(
          _categoryKeys[title]!.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black87,
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
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      price,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                width: 110.w,
                height: 110.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110.w,
                    height: 110.h,
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
