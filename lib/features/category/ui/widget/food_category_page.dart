import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/features/category/data/model/category_item.dart';
import 'package:deliva_eat/features/category/data/model/restaurant.dart';
import 'package:deliva_eat/features/category/ui/category_page.dart';
// ✅ استيراد القالب من ملفه الجديد
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  String _selectedFilter = 'الأعلى تقييماً';
  bool _loading = true;
  String? _error;
  final Map<String, String> _categoryNameToId = {};

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  final List<Map<String, dynamic>> _offersData = [
    {
      'title': 'خصم 50% على أول طلب',
      'subtitle': 'استخدم كود: NEW50',
      'image':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%33D%3D',
      'color': Colors.red,
    },
    {
      'title': 'توصيل مجاني هذا الأسبوع',
      'subtitle': 'لجميع المطاعم المشاركة',
      'image':
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1974&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%33D%3D',
      'color': Colors.blue,
    },
    {
      'title': 'وجبات عائلية بأسعار خاصة',
      'subtitle': 'اكتشف عروضنا الجديدة',
      'image':
          'https://images.unsplash.com/photo-1626074353765-517a681e40be?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%33D%3D',
      'color': Colors.green,
    },
  ];

  final List<CategoryItem> _categories = [
    CategoryItem(id: '1', name: 'Pizza', image: "assets/images/Pizza.png"),
    CategoryItem(id: '2', name: 'Burger', image: "assets/images/Burger.png"),
    CategoryItem(id: '3', name: 'Crepes', image: "assets/images/Crepes.png"),
    CategoryItem(
      id: '4',
      name: 'Desserts',
      image: "assets/images/Desserts.png",
    ),
    CategoryItem(id: '5', name: 'Grills', image: "assets/images/Grills.png"),
    CategoryItem(
      id: '6',
      name: 'Fried Chicken',
      image: "assets/images/Fried.png",
    ),
    CategoryItem(id: '7', name: 'Koshary', image: "assets/images/Koshary.png"),
    CategoryItem(
      id: '8',
      name: 'Breakfast',
      image: "assets/images/Breakfast.png",
    ),
    CategoryItem(id: '9', name: 'Pies', image: "assets/images/Pies.png"),
    CategoryItem(
      id: '10',
      name: 'Sandwich',
      image: "assets/images/Sandwich.png",
    ),
  ];

  final Map<String, List<Restaurant>> _restaurantsByCategory = {};

  List<Restaurant> get _filteredRestaurants {
    List<Restaurant> restaurants;
    if (_selectedBackendCategoryId.isNotEmpty) {
      restaurants = _restaurantsByCategory[_selectedBackendCategoryId] ?? [];
    } else {
      restaurants = _restaurantsByCategory['__top__'] ?? [];
    }
    final restaurantsCopy = List<Restaurant>.from(restaurants);
    switch (_selectedFilter) {
      case 'الأعلى تقييماً':
        restaurantsCopy.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'الأسرع توصيلاً':
        restaurantsCopy.sort((a, b) {
          int timeA = int.parse(a.deliveryTime.split('-')[0]);
          int timeB = int.parse(b.deliveryTime.split('-')[0]);
          return timeA.compareTo(timeB);
        });
        break;
      case 'توصيل مجاني':
        return restaurantsCopy.where((r) => r.deliveryFee == 0).toList();
    }
    return restaurantsCopy;
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
      _error = 'فشل في تحميل المطاعم، حاول لاحقاً';
    } finally {
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
      String message = 'فشل في تحميل مطاعم الفئة، حاول لاحقاً';
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
      if (mounted) setState(() => _loading = false);
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
    final isCurrentlySelected = _selectedLocalCategoryId == tappedLocalId;

    // Temporarily store the new state to apply it after potential async calls
    String newLocalCategoryId = '';
    String newBackendCategoryId = '';
    String newFilter = 'الأعلى تقييماً';

    if (isCurrentlySelected) {
      // If already selected, deselect it and fetch top rated
      newLocalCategoryId = '';
      newBackendCategoryId = '';
      newFilter = 'الأعلى تقييماً';
      // No need to await here, setState will trigger a rebuild and new fetch
      _fetchTopRatedRandom();
    } else {
      // If a new category is selected
      final category = _categories.firstWhere((cat) => cat.id == tappedLocalId);
      if (_categoryNameToId.isEmpty) {
        await _loadBackendCategoryMap(); // Ensure map is loaded before resolving
      }
      final resolvedBackendId = _resolveBackendCategoryId(category.name);

      if (resolvedBackendId != null && resolvedBackendId.isNotEmpty) {
        newLocalCategoryId = tappedLocalId;
        newBackendCategoryId = resolvedBackendId;
        newFilter = 'الأعلى تقييماً';
        // No need to await here, setState will trigger a rebuild and new fetch
        _fetchByCategory(resolvedBackendId);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('هذه الفئة غير متاحة حالياً')),
          );
        }
        // If category not available, keep current selection or deselect
        newLocalCategoryId = _selectedLocalCategoryId; // Keep current
        newBackendCategoryId = _selectedBackendCategoryId; // Keep current
      }
    }

    // Update all state variables at once to ensure consistency
    if (mounted) {
      setState(() {
        _selectedLocalCategoryId = newLocalCategoryId;
        _selectedBackendCategoryId = newBackendCategoryId;
        _selectedFilter = newFilter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReusableCategoryLayout(
      pageTitle: 'قسم الطعام',
      searchHintText: 'ابحث عن مطاعم، مأكولات...',
      offers: _offersData,
      categories: _categories,
      selectedCategoryId: _selectedLocalCategoryId,
      filters: const ['الأعلى تقييماً', 'الأسرع توصيلاً', 'توصيل مجاني'],
      selectedFilter: _selectedFilter,
      isLoading: _loading,
      errorMessage: _error,
      onCategorySelected: _handleCategoryTap, // ✅ الربط الصحيح موجود هنا
      onFilterSelected: (filter) {
        setState(() => _selectedFilter = filter);
      },
      onRetry: () {
        if (_selectedBackendCategoryId.isNotEmpty) {
          _fetchByCategory(_selectedBackendCategoryId);
        } else {
          _fetchTopRatedRandom();
        }
      },
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        return _buildRestaurantCard(context, _filteredRestaurants[index]);
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

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    // ... الكود الخاص ببناء كارت المطعم يبقى كما هو
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // context.push('${AppRoutes.restaurantDetails}/${restaurant.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                Hero(
                  tag:
                      'restaurant-card-${restaurant.id}', // أضفت كلمة card عشان يبقى فريد
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
                      child: Image.network(
                        restaurant.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
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
                            '${restaurant.deliveryTime} دقيقة',
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
                              ? "توصيل مجاني"
                              : "رسوم التوصيل: ${restaurant.deliveryFee} جنيه",
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
