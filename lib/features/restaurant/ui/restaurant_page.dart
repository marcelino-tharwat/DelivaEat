import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/core/widgets/mobile_only_layout.dart';
import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({super.key, required this.restaurantId, required this.restaurantName});

  final String restaurantId;
  final String restaurantName;

  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  bool _isFavorite = false;
  bool _loading = true;
  String? _error;

  // API
  late final Dio _dio;
  Map<String, dynamic>? _restaurant; // details
  List<String> _tabs = [];
  List<String> _badges = [];

  // Items per active tab
  String selectedCategory = '';
  final Map<String, List<Map<String, dynamic>>> _itemsByTab = {};

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  late final ScrollController _scrollController;
  final Map<String, GlobalKey> _categoryKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ));
  }

  bool _didFetch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didFetch) {
      _didFetch = true;
      _fetchDetails();
    }
  }

  Future<void> _fetchDetails() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get(
        'home/restaurant/details',
        queryParameters: {
          'restaurantId': widget.restaurantId,
          'lang': lang,
        },
      );
      final data = (res.data?['data'] ?? {}) as Map<String, dynamic>;
      _restaurant = data['restaurant'] as Map<String, dynamic>?;
      final List tabsRaw = (data['tabs'] ?? []) as List;
      _tabs = tabsRaw.map((e) => e.toString()).toList();
      final List badgesRaw = (data['badges'] ?? []) as List;
      _badges = badgesRaw.map((e) => e.toString().toLowerCase()).toList();

      // Localize default two tabs
      final l10n = AppLocalizations.of(context)!;
      final localizedTrending = l10n.categoryTrending;
      final localizedFree = l10n.categoryFree;
      // Ensure Trending/Free first
      _tabs.removeWhere((t) => t.toLowerCase() == 'trending' || t.toLowerCase() == 'free');
      // Localize known Food tabs coming from API (Soup, Appetizers, Pasta, Drinks)
      final localizedRest = _tabs.map((t) {
        final tl = t.toLowerCase();
        if (tl == 'soup') return l10n.categorySoup;
        if (tl == 'appetizers') return l10n.categoryAppetizers;
        if (tl == 'pasta') return l10n.categoryPasta;
        if (tl == 'drinks') return l10n.categoryDrinks;
        return t; // keep original for other types
      }).toList();
      _tabs = [localizedTrending, localizedFree, ...localizedRest];

      // Guard: if API returned empty tabs, use sensible defaults
      if (_tabs.isEmpty) {
        _tabs = [
          localizedTrending,
          localizedFree,
          l10n.categorySoup,
          l10n.categoryAppetizers,
          l10n.categoryPasta,
          l10n.categoryDrinks,
        ];
      }

      // Build keys
      _categoryKeys.clear();
      for (final t in _tabs) {
        _categoryKeys[t] = GlobalKey();
      }
      if (_tabs.isNotEmpty) {
        selectedCategory = _tabs.first;
        await _fetchItemsForTab(selectedCategory);
      }
    } catch (e) {
      // Fallback: show default tabs so UI works even if API failed (e.g., device cannot reach server)
      final l10n = AppLocalizations.of(context)!;
      _error = l10n.failedToLoadRestaurants;
      _tabs = [
        l10n.categoryTrending,
        l10n.categoryFree,
        l10n.categorySoup,
        l10n.categoryAppetizers,
        l10n.categoryPasta,
        l10n.categoryDrinks,
      ];
      _categoryKeys.clear();
      for (final t in _tabs) {
        _categoryKeys[t] = GlobalKey();
      }
      selectedCategory = _tabs.first;
      await _fetchItemsForTab(selectedCategory);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchItemsForTab(String tab) async {
    final lang = Localizations.localeOf(context).languageCode;
    try {
      final apiTab = _mapDisplayTabToApi(tab);
      final res = await _dio.get(
        'home/foods/by-restaurant',
        queryParameters: {
          'restaurantId': widget.restaurantId,
          'tab': apiTab,
          'lang': lang,
          'limit': 50,
        },
      );
      final List list = (res.data?['data'] ?? []) as List;
      _itemsByTab[tab] = list.cast<Map<String, dynamic>>();
      if (mounted) setState(() {});
    } catch (_) {
      _itemsByTab[tab] = [];
    }
  }

  String _mapDisplayTabToApi(String tab) {
    final t = tab.toLowerCase();
    final l10n = AppLocalizations.of(context)!;
    if (t == l10n.categoryTrending.toLowerCase()) return 'Trending';
    if (t == l10n.categoryFree.toLowerCase()) return 'Free';
    if (t == l10n.categorySoup.toLowerCase()) return 'Soup';
    if (t == l10n.categoryAppetizers.toLowerCase()) return 'Appetizers';
    if (t == l10n.categoryPasta.toLowerCase()) return 'Pasta';
    if (t == l10n.categoryDrinks.toLowerCase()) return 'Drinks';
    return tab; // fallback uses same label (Pharmacy/Grocery/Markets subcats)
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatPrice(dynamic value) {
    try {
      if (value == null) return '';
      final numVal = value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0.0;
      // Adjust currency label if needed
      return 'EGP ${numVal.toStringAsFixed(numVal % 1 == 0 ? 0 : 2)}';
    } catch (_) {
      return '';
    }
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
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // الخلفية: صورة الغلاف من المطعم
                Container(
                  height: 280.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        (_restaurant?['coverImage'] ?? _restaurant?['image'] ?? 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800') as String,
                      ),
                      fit: BoxFit.cover,
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
                // اللوجو (بدل الشارة الحمراء)
                Positioned(
                  top: 90.h,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 36.r,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        (_restaurant?['image'] ?? 'https://placehold.co/160x160/png?text=Logo') as String,
                      ),
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
                          ..._tabs
                              .map((category) => _buildCategoryTab(category))
                              .toList(),
                        ],
                      ),
                    ),
                  ),

                  // قائمة الطعام (Food Items) - Sections for each category
                  Column(
                    children: _tabs.map((category) {
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
                            ...(_itemsByTab[category] ?? [])
                                .map((item) => Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: _buildFoodItem(
                                        (item['nameAr'] ?? item['name'] ?? '').toString(),
                                        (item['descriptionAr'] ?? item['description'] ?? '').toString(),
                                        _formatPrice(item['price']),
                                        (item['image'] ?? '').toString(),
                                      ),
                                    ))
                                .toList(),
                            if ((_itemsByTab[category] ?? []).isEmpty)
                              Text(
                                _error == null ? 'لا توجد بيانات' : l10n.failedToLoadRestaurants,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
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
        if (!_itemsByTab.containsKey(title)) {
          _fetchItemsForTab(title);
        }
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
