import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/category/data/model/category_item.dart';
import 'package:deliva_eat/features/category/data/model/restaurant.dart';
import 'package:deliva_eat/features/category/ui/category_page.dart';
// ✅ استيراد القالب من ملفه الجديد
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

// هذا الملف يحتوي فقط على الصفحة الذكية الخاصة بالطعام
class FoodCategoriesPage extends StatefulWidget {
  const FoodCategoriesPage({super.key, this.categoryId = ""});
  final String categoryId;
  @override
  State<FoodCategoriesPage> createState() => _FoodCategoriesPageState();
}

class _FoodCategoriesPageState extends State<FoodCategoriesPage> {
  // ... كل الكود الخاص بالمنطق والحالة يبقى كما هو بدون أي تغيير ...
  // لقد قمت بنسخه كما هو لأنه صحيح
  String _selectedLocalCategoryId = '';
  String _selectedBackendCategoryId = '';
  String _selectedFilter = '';
  bool _loading = true;
  String? _error;
  final Map<String, String> _categoryNameToId = {};
  List<Restaurant> _filteredRestaurants = [];

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  List<Map<String, dynamic>> get _offersData {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'title': l10n.discount50OnFirstOrder,
        'subtitle': l10n.useCodeNew50,
        'image':
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%33D%3D',
        'color': Colors.red,
      },
      {
        'title': l10n.freeDeliveryThisWeek,
        'subtitle': l10n.forAllParticipatingRestaurants,
        'image':
            'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1974&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%33D%3D',
        'color': Colors.blue,
      },
      {
        'title': l10n.familyMealsAtSpecialPrices,
        'subtitle': l10n.discoverOurNewOffers,
        'image':
            'https://images.unsplash.com/photo-1626074353765-517a681e40be?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%33D%3D',
        'color': Colors.green,
      },
    ];
  }

  List<CategoryItem> _categories = [];
  bool _filterInitialized = false;

  final Map<String, List<Restaurant>> _restaurantsByCategory = {};
  void _updateAndFilterRestaurants(AppLocalizations l10n) {
    List<Restaurant> sourceList;
    if (_selectedBackendCategoryId.isNotEmpty) {
      sourceList = _restaurantsByCategory[_selectedBackendCategoryId] ?? [];
    } else {
      sourceList = _restaurantsByCategory['__top__'] ?? [];
    }

    final restaurantsCopy = List<Restaurant>.from(sourceList);
    switch (_selectedFilter) {
      case 'الأعلى تقييماً':
      case var filter when filter == l10n.highestRated:
        restaurantsCopy.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'الأسرع توصيلاً':
      case var filter when filter == l10n.fastestDelivery:
        restaurantsCopy.sort((a, b) {
          int timeA = int.tryParse(a.deliveryTime.split('-')[0].trim()) ?? 99;
          int timeB = int.tryParse(b.deliveryTime.split('-')[0].trim()) ?? 99;
          return timeA.compareTo(timeB);
        });
        break;
      case 'توصيل مجاني':
      case var filter when filter == l10n.freeDelivery:
        // نستخدم where لإنشاء قائمة جديدة مفلترة
        _filteredRestaurants = restaurantsCopy
            .where((r) => r.deliveryFee == 0)
            .toList();
        return; // الخروج مبكراً لتجنب إعادة الكتابة على القائمة
    }
    _filteredRestaurants = restaurantsCopy;
  }

  @override
  void initState() {
    super.initState();
    _selectedBackendCategoryId = widget.categoryId;
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadBackendCategoryMap();
    if (mounted) {
      if (_selectedBackendCategoryId.isEmpty) {
        _fetchTopRatedRandom();
      } else {
        _updateLocalCategoryFromBackendId(_selectedBackendCategoryId);
        _fetchByCategory(_selectedBackendCategoryId);
      }
    }
  }

  Future<void> _fetchTopRatedRandom() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get(
        'home/restaurants',
        queryParameters: {'type': 'topRated', 'limit': 20, 'lang': lang},
      );
      final List data = (res.data?['data'] ?? []) as List;
      final list = data
          .map((e) => _mapApiToRestaurant(e as Map<String, dynamic>))
          .toList();
      list.shuffle();
      _restaurantsByCategory['__top__'] = list;
    } catch (e) {
      _error = AppLocalizations.of(context)!.failedToLoadRestaurants;
    } finally {
      _updateAndFilterRestaurants(AppLocalizations.of(context)!); // ✅ استدعاء الدالة بعد جلب البيانات

      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchByCategory(String categoryId) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get(
        'home/restaurants/by-category',
        queryParameters: {
          'categoryId': categoryId,
          'limit': 50,
          'lang': lang,
          'sort': 'topRated',
        },
      );
      final List data = (res.data?['data'] ?? []) as List;
      final list = data
          .map((e) => _mapApiToRestaurant(e as Map<String, dynamic>))
          .toList();
      _restaurantsByCategory[categoryId] = list;
    } catch (e) {
      String message = AppLocalizations.of(context)!.failedToLoadCategoryRestaurants;
      if (e is DioException) {
        final data = e.response?.data;
        final serverMsg = (data is Map)
            ? (data['error']?['message'] ?? data['message'])
            : null;
        if (serverMsg is String && serverMsg.isNotEmpty) message = serverMsg;
      }
      _error = message;
      await _fetchTopRatedRandom();
    } finally {
      if (mounted) {
        _updateAndFilterRestaurants(AppLocalizations.of(context)!); // ✅ استدعاء الدالة بعد جلب البيانات
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadBackendCategoryMap() async {
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get(
        'home/categories',
        queryParameters: {'lang': lang},
      );
      final List list = (res.data?['data'] ?? []) as List;
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          final id = (item['_id'] ?? '').toString();
          final name = (item['name'] ?? '').toString();
          final nameAr = (item['nameAr'] ?? '').toString();
          if (id.isNotEmpty) {
            if (name.isNotEmpty) _categoryNameToId[name] = id;
            if (nameAr.isNotEmpty) _categoryNameToId[nameAr] = id;
          }
        }
      }
    } catch (_) {}
  }

  String? _resolveRootIdForFood() {
    // Try to find a root category id for Food by name (en/ar)
    for (final entry in _categoryNameToId.entries) {
      final k = entry.key.toLowerCase();
      if (k == 'food' || k.contains('food') || k == 'طعام' || k.contains('طعام')) {
        return entry.value;
      }
    }
    return null;
  }

  void _updateLocalCategoryFromBackendId(String backendId) {
    for (var entry in _categoryNameToId.entries) {
      if (entry.value == backendId) {
        final categoryName = entry.key;
        final matchingCategory = _categories.firstWhere(
          (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
          orElse: () => CategoryItem(id: '', name: '', image: ''),
        );
        if (matchingCategory.id.isNotEmpty && mounted) {
          setState(() => _selectedLocalCategoryId = matchingCategory.id);
        }
        break;
      }
    }
  }

  String? _resolveBackendCategoryId(String displayName) {
    if (_categoryNameToId.containsKey(displayName))
      return _categoryNameToId[displayName];
    final lower = displayName.toLowerCase();
    for (final entry in _categoryNameToId.entries) {
      if (entry.key.toLowerCase() == lower) return entry.value;
    }
    return null;
  }

  // In _FoodCategoriesPageState

  void _handleCategoryTap(String tappedLocalId) async {
    final l10n = AppLocalizations.of(context)!;
    final isCurrentlySelected = _selectedLocalCategoryId == tappedLocalId;

    if (isCurrentlySelected) {
      // إلغاء التحديد والعودة للأعلى تقييماً
      setState(() {
        _selectedLocalCategoryId = '';
        _selectedBackendCategoryId = '';
        _selectedFilter = l10n.highestRated;
      });
      _fetchTopRatedRandom();
    } else {
      // تحديد فئة جديدة
      final category = _categories.firstWhere((cat) => cat.id == tappedLocalId);
      if (_categoryNameToId.isEmpty) {
        await _loadBackendCategoryMap();
      }
      final resolvedBackendId = _resolveBackendCategoryId(category.name);

      if (resolvedBackendId != null && resolvedBackendId.isNotEmpty) {
        setState(() {
          _selectedLocalCategoryId = tappedLocalId;
          _selectedBackendCategoryId = resolvedBackendId;
          _selectedFilter = l10n.highestRated;
        });
        _fetchByCategory(resolvedBackendId);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.thisCategoryNotAvailable)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_categories.isEmpty) {
      _categories = [
        CategoryItem(id: '1', name: l10n.categoryPizza, image: "assets/images/Pizza.png"),
        CategoryItem(id: '2', name: l10n.categoryBurger, image: "assets/images/Burger.png"),
        CategoryItem(id: '3', name: l10n.categoryCrepes, image: "assets/images/Crepes.png"),
        CategoryItem(id: '4', name: l10n.categoryDesserts, image: "assets/images/Desserts.png"),
        CategoryItem(id: '5', name: l10n.categoryGrills, image: "assets/images/Grills.png"),
        CategoryItem(id: '6', name: l10n.categoryFriedChicken, image: "assets/images/Fried.png"),
        CategoryItem(id: '7', name: l10n.categoryKoshary, image: "assets/images/Koshary.png"),
        CategoryItem(id: '8', name: l10n.categoryBreakfast, image: "assets/images/Breakfast.png"),
        CategoryItem(id: '9', name: l10n.categoryPies, image: "assets/images/Pies.png"),
        CategoryItem(id: '10', name: l10n.categorySandwich, image: "assets/images/Sandwich.png"),
      ];
    }
    if (!_filterInitialized) {
      _selectedFilter = l10n.highestRated;
      _filterInitialized = true;
    }
    return ReusableCategoryLayout(
      pageTitle: l10n.foodSectionTitle,
      searchHintText: l10n.searchRestaurantsHint,
      offers: _offersData,
      categories: _categories,
      selectedCategoryId: _selectedLocalCategoryId,
      filters: [l10n.highestRated, l10n.fastestDelivery, l10n.freeDelivery],
      selectedFilter: _selectedFilter,
      isLoading: _loading,
      errorMessage: _error,
      onCategorySelected: _handleCategoryTap, // ✅ الربط الصحيح موجود هنا
      onSearchTap: () {
        // Resolve Food root id; fall back to Arabic/English name if id not available
        final rootId = _resolveRootIdForFood() ?? _selectedBackendCategoryId;
        final categoryParam = (rootId != null && rootId.isNotEmpty) ? rootId : 'Food';
        context.push(AppRoutes.searchPage, extra: {
          'categoryId': categoryParam,
          'type': 'all',
          'categoryType': 'food',
        });
      },
      onFilterSelected: (filter) {
        setState(() {
          _selectedFilter = filter;
          _updateAndFilterRestaurants(l10n); // ✅ استدعاء الدالة عند تغيير الفلتر
        });
      },
      onRetry: () {
        if (_selectedBackendCategoryId.isNotEmpty) {
          _fetchByCategory(_selectedBackendCategoryId);
        } else {
          _fetchTopRatedRandom();
        }
      },
      itemCount: _filteredRestaurants.length, // ✅ استخدام القائمة المفلترة
      itemBuilder: (context, index) {
        // بناء الويدجت الجديدة بدلاً من الدالة
        return _FoodCard(restaurant: _filteredRestaurants[index], l10n: l10n);
      },
    );
  }

  Restaurant _mapApiToRestaurant(Map<String, dynamic> json) {
    final nameAr = (json['nameAr'] ?? '') as String;
    final name = (json['name'] ?? '') as String;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Restaurant(
      id: (json['_id'] ?? '').toString(),
      name: isArabic && nameAr.isNotEmpty ? nameAr : name,
      image: (json['image'] ?? '') as String,
      rating: ((json['rating'] ?? 0) as num).toDouble(),
      reviewsCount: ((json['reviewCount'] ?? 0) as num).toInt(),
      deliveryTime: (json['deliveryTime'] ?? '30-45').toString().replaceAll(
        ' دقيقة',
        '',
      ),
      deliveryFee: ((json['deliveryFee'] ?? 0) as num).toInt(),
      isFavorite: (json['isFavorite'] ?? false) as bool,
      isPromoted: (json['isTopRated'] ?? false) as bool,
      minimumOrder: ((json['minimumOrder'] ?? 0) as num).toInt(),
      cuisine: '',
      tags: const [],
    );
  }
}

// --- تم فصل كارت الطعام في ويدجت خاصة بها ---
class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.restaurant, required this.l10n});

  final Restaurant restaurant;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push(
              AppRoutes.restaurantPage,
              extra: {
                'restaurantId': restaurant.id,
                'restaurantName': restaurant.name,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Hero(
                  tag: 'restaurant-card-${restaurant.id}',
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.restaurant,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant.deliveryTime} ${l10n.minutes}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          restaurant.deliveryFee == 0
                              ? l10n.freeDelivery
                              : l10n.deliveryFee(restaurant.deliveryFee.toString()),
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
