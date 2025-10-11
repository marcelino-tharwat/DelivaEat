import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/core/widgets/mobile_only_layout.dart';
import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/home/cubit/home_cubit.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/core/network/dio_factory.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/core/routing/routes.dart';

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

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
  late final ScrollController _scrollController;

  Future<void> _toggleFavorite() async {
    // Optimistic UI update
    final newVal = !_isFavorite;
    setState(() {
      _isFavorite = newVal;
    });
    // Propagate to Home favorites state and backend
    if (!mounted) return;

    // Prepare payload and also update HomeCubit directly when available
    final lang = Localizations.localeOf(context).languageCode;
    final m = _restaurant ?? <String, dynamic>{};
    final model = RestaurantModel(
      id: (m['_id']?.toString() ?? widget.restaurantId),
      name: (m['name'] ?? '') as String,
      nameAr: (m['nameAr'] ?? m['name'] ?? '') as String,
      description: (m['description'] as String?) ?? (m['descriptionAr'] as String?),
      descriptionAr: (m['descriptionAr'] as String?) ?? (m['description'] as String?),
      image: (m['image'] ?? '') as String,
      coverImage: m['coverImage'] as String?,
      rating: (m['rating'] is num) ? (m['rating'] as num).toDouble() : null,
      reviewCount: m['reviewCount'] is int ? m['reviewCount'] as int : int.tryParse('${m['reviewCount'] ?? ''}'),
      deliveryTime: m['deliveryTime']?.toString(),
      deliveryFee: (m['deliveryFee'] is num) ? (m['deliveryFee'] as num).toDouble() : null,
      minimumOrder: (m['minimumOrder'] is num) ? (m['minimumOrder'] as num).toDouble() : null,
      isOpen: m['isOpen'] as bool?,
      isActive: m['isActive'] as bool?,
      // Pass the PRE-TOGGLE state so HomeCubit toggles to newVal internally
      isFavorite: !newVal,
      isTopRated: m['isTopRated'] as bool?,
      address: m['address'] as String?,
      phone: m['phone'] as String?,
    );

    // 1) Primary path: update HomeCubit immediately so Home favorites reflects the change
    bool usedHomeCubit = false;
    try {
      final hc = context.read<HomeCubit>();
      if (hc.state is HomeSuccess) {
        usedHomeCubit = true;
        await hc.toggleFavorite(
          restaurantId: widget.restaurantId,
          lang: lang,
          baseOverride: model,
        );
      }
    } catch (_) {
      // ignore – we'll use backend fallback below if needed
    }

    // 2) Backend fallback: only if HomeCubit isn't available
    if (!usedHomeCubit) {
      try {
        final res = await _dio.post(
          ApiConstant.toggleFavoriteUrl,
          data: {'restaurantId': widget.restaurantId},
          queryParameters: {'lang': lang},
        );
        final map = res.data as Map<String, dynamic>?;
        if (map?['success'] == true && map?['data'] is Map<String, dynamic>) {
          final data = map!['data'] as Map<String, dynamic>;
          final serverFav = data['isFavorite'] == true;
          if (mounted) {
            setState(() {
              _isFavorite = serverFav; // reconcile with server
            });
          }
        } else {
          // rollback on unexpected response
          if (mounted) {
            setState(() {
              _isFavorite = !newVal;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update favorite')),
            );
          }
        }
      } catch (_) {
        // rollback on error
        if (mounted) {
          setState(() {
            _isFavorite = !newVal;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connection error while updating favorite')),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _dio = DioFactory.getDio();
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
        queryParameters: {'restaurantId': widget.restaurantId, 'lang': lang},
      );
      final data = (res.data?['data'] ?? {}) as Map<String, dynamic>;
      _restaurant = data['restaurant'] as Map<String, dynamic>?;
      // Initialize favorite state from API if available
      final favFromApi = (_restaurant?['isFavorite'] ?? false);
      _isFavorite = favFromApi is bool ? favFromApi : false;
      final List tabsRaw = (data['tabs'] ?? []) as List;
      _tabs = tabsRaw.map((e) => e.toString()).toList();
      final List badgesRaw = (data['badges'] ?? []) as List;
      _badges = badgesRaw.map((e) => e.toString().toLowerCase()).toList();

      // Localize default two tabs
      final l10n = AppLocalizations.of(context)!;
      final localizedTrending = l10n.categoryTrending;
      final localizedFree = l10n.categoryFree;
      // Ensure Trending/Free first
      _tabs.removeWhere(
        (t) => t.toLowerCase() == 'trending' || t.toLowerCase() == 'free',
      );
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
      final numVal = value is num
          ? value.toDouble()
          : double.tryParse(value.toString()) ?? 0.0;
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
    return WillPopScope(
      onWillPop: () async {
        final lang = Localizations.localeOf(context).languageCode;
        final m = _restaurant ?? <String, dynamic>{};
        final base = RestaurantModel(
          id: (m['_id']?.toString() ?? widget.restaurantId),
          name: (m['name'] ?? '') as String,
          nameAr: (m['nameAr'] ?? m['name'] ?? '') as String,
          description: (m['description'] as String?) ?? (m['descriptionAr'] as String?),
          descriptionAr: (m['descriptionAr'] as String?) ?? (m['description'] as String?),
          image: (m['image'] ?? '') as String,
          coverImage: m['coverImage'] as String?,
          rating: (m['rating'] is num) ? (m['rating'] as num).toDouble() : null,
          reviewCount: m['reviewCount'] is int ? m['reviewCount'] as int : int.tryParse('${m['reviewCount'] ?? ''}'),
          deliveryTime: m['deliveryTime']?.toString(),
          deliveryFee: (m['deliveryFee'] is num) ? (m['deliveryFee'] as num).toDouble() : null,
          minimumOrder: (m['minimumOrder'] is num) ? (m['minimumOrder'] as num).toDouble() : null,
          isOpen: m['isOpen'] as bool?,
          isActive: m['isActive'] as bool?,
          isFavorite: _isFavorite,
          isTopRated: m['isTopRated'] as bool?,
          address: m['address'] as String?,
          phone: m['phone'] as String?,
        );
        Navigator.of(context).pop({
          'restaurantId': widget.restaurantId,
          'lang': lang,
          'isFavorite': _isFavorite,
          'base': base.toJson(),
        });
        return false;
      },
      child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MobileOnlyLayout(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // --- الجزء الأول: الهيدر (صورة + لوجو) ---
            if (_loading)
              const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // الخلفية: صورة الغلاف من المطعم
                    Container(
                      height: 280.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            (_restaurant?['coverImage'] ??
                                    _restaurant?['image'] ??
                                    'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800')
                                as String,
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
                        onTap: () {
                          final lang = Localizations.localeOf(context).languageCode;
                          final m = _restaurant ?? <String, dynamic>{};
                          final base = RestaurantModel(
                            id: (m['_id']?.toString() ?? widget.restaurantId),
                            name: (m['name'] ?? '') as String,
                            nameAr: (m['nameAr'] ?? m['name'] ?? '') as String,
                            description: (m['description'] as String?) ?? (m['descriptionAr'] as String?),
                            descriptionAr: (m['descriptionAr'] as String?) ?? (m['description'] as String?),
                            image: (m['image'] ?? '') as String,
                            coverImage: m['coverImage'] as String?,
                            rating: (m['rating'] is num) ? (m['rating'] as num).toDouble() : null,
                            reviewCount: m['reviewCount'] is int ? m['reviewCount'] as int : int.tryParse('${m['reviewCount'] ?? ''}'),
                            deliveryTime: m['deliveryTime']?.toString(),
                            deliveryFee: (m['deliveryFee'] is num) ? (m['deliveryFee'] as num).toDouble() : null,
                            minimumOrder: (m['minimumOrder'] is num) ? (m['minimumOrder'] as num).toDouble() : null,
                            isOpen: m['isOpen'] as bool?,
                            isActive: m['isActive'] as bool?,
                            isFavorite: _isFavorite,
                            isTopRated: m['isTopRated'] as bool?,
                            address: m['address'] as String?,
                            phone: m['phone'] as String?,
                          );
                          Navigator.of(context).pop({
                            'restaurantId': widget.restaurantId,
                            'lang': lang,
                            'isFavorite': _isFavorite,
                            'base': base.toJson(),
                          });
                        },
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                        width: 130.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            (_restaurant?['image'] ??
                                    'https://placehold.co/160x160/png?text=Logo')
                                as String,
                            fit: BoxFit.cover, // عشان تملى المساحة بشكل مظبوط
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
                          color: Theme.of(context).cardColor,
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
              ),

            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 20.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade800,
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
                  ],
                ),
              ),
            ),

            // قائمة الطعام (Food Items) - Sections for each category
            ..._tabs
                .map((category) {
                  return [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _CategoryHeaderDelegate(category),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        ...(_itemsByTab[category] ?? [])
                            .asMap()
                            .entries
                            .map((entry) {
                              final idx = entry.key;
                              final item = entry.value;
                              final foodId = (item['_id'] ?? item['id'] ?? '').toString();
                              final isFav = (item['isFavorite'] == true);
                              return Container(
                                color: Theme.of(context).cardColor,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 16.h,
                                    left: 16.w,
                                    right: 16.w,
                                  ),
                                  child: _buildFoodItem(
                                    (item['nameAr'] ?? item['name'] ?? '').toString(),
                                    (item['descriptionAr'] ?? item['description'] ?? '').toString(),
                                    _formatPrice(item['price']),
                                    (item['image'] ?? '').toString(),
                                    foodId,
                                    isFav,
                                    () async {
                                      // Determine latest value from source of truth, not the captured isFav
                                      bool newFav;
                                      Map<String, dynamic>? baseMap;
                                      final list0 = _itemsByTab[category] ?? [];
                                      if (idx >= 0 && idx < list0.length) {
                                        baseMap = Map<String, dynamic>.from(list0[idx]);
                                        final curr = (baseMap['isFavorite'] == true);
                                        newFav = !curr;
                                      } else {
                                        newFav = !isFav;
                                      }
                                      // Optimistic local update
                                      setState(() {
                                        final list = _itemsByTab[category] ?? [];
                                        if (idx >= 0 && idx < list.length) {
                                          list[idx] = {
                                            ...list[idx],
                                            'isFavorite': newFav,
                                          };
                                          _itemsByTab[category] = List<Map<String, dynamic>>.from(list);
                                        }
                                      });
                                      final lang = Localizations.localeOf(context).languageCode;
                                      // Propagate to global state + backend
                                      bool sent = false;
                                      try {
                                        // Build baseOverride from current item so cubit can add/remove globally
                                        final base = FoodModel(
                                          id: foodId,
                                          name: (item['name'] ?? '') as String? ?? '',
                                          nameAr: (item['nameAr'] ?? item['name'] ?? '') as String? ?? '',
                                          description: item['description'] as String?,
                                          descriptionAr: item['descriptionAr'] as String?,
                                          image: (item['image'] ?? '') as String? ?? '',
                                          price: (item['price'] is num) ? (item['price'] as num).toDouble() : double.tryParse('${item['price'] ?? ''}'),
                                          originalPrice: (item['originalPrice'] is num) ? (item['originalPrice'] as num).toDouble() : double.tryParse('${item['originalPrice'] ?? ''}'),
                                          rating: (item['rating'] is num) ? (item['rating'] as num).toDouble() : double.tryParse('${item['rating'] ?? ''}'),
                                          reviewCount: item['reviewCount'] is int ? item['reviewCount'] as int : int.tryParse('${item['reviewCount'] ?? ''}'),
                                          preparationTime: item['preparationTime']?.toString(),
                                          isAvailable: (item['isAvailable'] ?? true) == true,
                                          isPopular: (item['isPopular'] ?? false) == true,
                                          isBestSelling: (item['isBestSelling'] ?? false) == true,
                                          isFavorite: newFav,
                                          restaurant: null,
                                          ingredients: (item['ingredients'] as List?)?.map((e) => e.toString()).toList(),
                                          allergens: (item['allergens'] as List?)?.map((e) => e.toString()).toList(),
                                          tags: (item['tags'] as List?)?.map((e) => e.toString()).toList(),
                                        );
                                        await context.read<HomeCubit>().toggleFoodFavorite(
                                          foodId: foodId,
                                          lang: lang,
                                          baseOverride: base,
                                        );
                                        sent = true;
                                      } catch (_) {
                                        // ignore and try backend fallback
                                      }
                                      if (!sent) {
                                        try {
                                          final res = await _dio.post(
                                            ApiConstant.toggleFoodFavoriteUrl,
                                            data: { 'foodId': foodId },
                                            queryParameters: { 'lang': lang },
                                          );
                                          final ok = (res.data is Map) && (res.data['success'] == true);
                                          if (!ok) {
                                            throw Exception('failed');
                                          }
                                        } catch (_) {
                                          // rollback local toggle on failure
                                          if (mounted) {
                                            setState(() {
                                              final list = _itemsByTab[category] ?? [];
                                              if (idx >= 0 && idx < list.length) {
                                                list[idx] = {
                                                  ...list[idx],
                                                  'isFavorite': !newFav,
                                                };
                                                _itemsByTab[category] = List<Map<String, dynamic>>.from(list);
                                              }
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Connection error while updating favorite')),
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                              );
                            })
                            .toList(),
                        if ((_itemsByTab[category] ?? []).isEmpty)
                          Container(
                            color: Theme.of(context).cardColor,
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Text(
                                _error == null
                                    ? 'لا توجد بيانات'
                                    : l10n.failedToLoadRestaurants,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ];
                })
                .expand((element) => element)
                .toList(),

          ],
        ),
      ),
      ),
    );
  }

  // Tabs builder
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
                  : Theme.of(context).textTheme.bodyMedium?.color,
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
    String foodId,
    bool isFavorite,
    VoidCallback onToggleFavorite,
  ) {
    return InkWell(
      onTap: () {
        context.push(AppRoutes.productDetailsPage, extra: {
          'foodId': foodId,
          'title': title,
          'image': imageUrl,
          'price': price,
          'isFavorite': isFavorite,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            price,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onToggleFavorite,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String category;

  _CategoryHeaderDelegate(this.category);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Theme.of(context).cardColor,
      child: Text(category, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  @override
  double get maxExtent => 60.h;

  @override
  double get minExtent => 60.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
