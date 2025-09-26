import 'package:deliva_eat/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:deliva_eat/core/network/api_constant.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, this.title = "", this.categoryId = ""});
  final String title;
  final String categoryId;
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _selectedCategoryId = '';
  String _selectedFilter = 'الأعلى تقييماً';
  bool _loading = true;
  String? _error;
  // name (en/ar) -> backend categoryId
  final Map<String, String> _categoryNameToId = {};

  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstant.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  final List<FoodCategory> _categories = [
    FoodCategory(
      id: '1',
      name: 'Pizza',
      image: "assets/images/Pizza.png",
      // color: const Color(0xFFE63946),
    ),
    FoodCategory(id: '2', name: 'Burger', image: "assets/images/Burger.png"),
    FoodCategory(id: '3', name: 'Crepes', image: "assets/images/Crepes.png"),
    FoodCategory(
      id: '4',
      name: 'Desserts',
      image: "assets/images/Desserts.png",
    ),
    FoodCategory(id: '5', name: 'Grills', image: "assets/images/Grills.png"),
    FoodCategory(
      id: '6',
      name: 'Fried Chicken',
      image: "assets/images/Fried.png",
    ),
    FoodCategory(id: '7', name: 'Koshary', image: "assets/images/Koshary.png"),
    FoodCategory(
      id: '8',
      name: 'Breakfast',
      image: "assets/images/Breakfast.png",
    ),
    FoodCategory(id: '9', name: 'Pies', image: "assets/images/Pies.png"),
    FoodCategory(
      id: '10',
      name: 'Sandwich',
      image: "assets/images/Sandwich.png",
    ),
  ];

  final Map<String, List<Restaurant>> _restaurantsByCategory = {
    '1': [
      Restaurant(
        id: '1',
        name: 'برجر كينج',
        image:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.5,
        reviewsCount: 1250,
        deliveryTime: '30-45',
        deliveryFee: 15,
        originalDeliveryFee: 20,
        cuisine: 'وجبات سريعة أمريكية',
        discount: 'خصم 10%',
        isFavorite: false,
        isPromoted: true,
        tags: ['وجبات سريعة', 'برجر', 'أمريكي'],
        minimumOrder: 50,
      ),
      Restaurant(
        id: '2',
        name: 'ماكدونالدز',
        image:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.2,
        reviewsCount: 2100,
        deliveryTime: '25-40',
        deliveryFee: 12,
        cuisine: 'وجبات سريعة أمريكية',
        isFavorite: true,
        tags: ['وجبات سريعة', 'برجر', 'إفطار'],
        minimumOrder: 40,
      ),
      Restaurant(
        id: '3',
        name: 'كايرو برجر',
        image:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
        reviewsCount: 890,
        deliveryTime: '35-50',
        deliveryFee: 0,
        originalDeliveryFee: 18,
        cuisine: 'برجر محلي',
        discount: 'توصيل مجاني',
        isFavorite: false,
        tags: ['محلي', 'برجر', 'مصري'],
        minimumOrder: 60,
      ),
    ],
    '2': [
      Restaurant(
        id: '4',
        name: 'بيتزا هت',
        image:
            'https://images.unsplash.com/photo-1534308960654-e73722956c2e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.0,
        reviewsCount: 1500,
        deliveryTime: '40-55',
        deliveryFee: 18,
        cuisine: 'بيتزا إيطالية',
        isFavorite: false,
        tags: ['بيتزا', 'إيطالي', 'وجبات سريعة'],
        minimumOrder: 70,
      ),
      Restaurant(
        id: '5',
        name: 'دومينوز بيتزا',
        image:
            'https://images.unsplash.com/photo-1534308960654-e73722956c2e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 3.8,
        reviewsCount: 1800,
        deliveryTime: '30-45',
        deliveryFee: 15,
        cuisine: 'بيتزا أمريكية',
        isFavorite: true,
        tags: ['بيتزا', 'أمريكي'],
        minimumOrder: 60,
      ),
    ],
    '3': [
      Restaurant(
        id: '6',
        name: 'كنتاكي',
        image:
            'https://images.unsplash.com/photo-1563242784-0672e8169994?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.3,
        reviewsCount: 2000,
        deliveryTime: '35-50',
        deliveryFee: 16,
        cuisine: 'دجاج مقلي',
        isFavorite: false,
        tags: ['دجاج', 'مقلي', 'وجبات سريعة'],
        minimumOrder: 55,
      ),
    ],
  };

  List<Restaurant> get _filteredRestaurants {
    List<Restaurant> restaurants;
    if (_selectedCategoryId.isNotEmpty) {
      restaurants = _restaurantsByCategory[_selectedCategoryId] ?? [];
    } else {
      // Prefer the fetched top list if present; otherwise fall back to any local demo data
      if (_restaurantsByCategory.containsKey('__top__')) {
        restaurants = _restaurantsByCategory['__top__'] ?? [];
      } else {
        restaurants = _restaurantsByCategory.values.expand((list) => list).toList();
      }
    }

    switch (_selectedFilter) {
      case 'الأعلى تقييماً':
        restaurants.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'الأسرع توصيلاً':
        restaurants.sort((a, b) {
          int timeA = int.parse(a.deliveryTime.split('-')[0]);
          int timeB = int.parse(b.deliveryTime.split('-')[0]);
          return timeA.compareTo(timeB);
        });
        break;
      case 'توصيل مجاني':
        restaurants = restaurants.where((r) => r.deliveryFee == 0).toList();
        break;
      default:
        restaurants.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
    }

    return restaurants;
  }

  @override
  void initState() {
    super.initState();
    // Initialize selection from route if provided
    _selectedCategoryId = widget.categoryId;
    // Fetch initial data
    _loadBackendCategoryMap().whenComplete(() {
      if (_selectedCategoryId.isEmpty) {
        _fetchTopRatedRandom();
      } else {
        _fetchByCategory(_selectedCategoryId);
      }
    });
  }

  Future<void> _fetchTopRatedRandom() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get('home/restaurants', queryParameters: {
        'type': 'topRated',
        'limit': 20,
        'lang': lang,
      });
      final List data = (res.data?['data'] ?? []) as List;
      final list = data.map((e) => _mapApiToRestaurant(e as Map<String, dynamic>)).toList();
      list.shuffle();
      _restaurantsByCategory['__top__'] = list;
      _selectedCategoryId = '';
    } catch (e) {
      _error = 'فشل في تحميل المطاعم، حاول لاحقاً';
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchByCategory(String categoryId) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get('home/restaurants/by-category', queryParameters: {
        'categoryId': categoryId,
        'limit': 50,
        'lang': lang,
        'sort': 'topRated',
      });
      final List data = (res.data?['data'] ?? []) as List;
      final list = data.map((e) => _mapApiToRestaurant(e as Map<String, dynamic>)).toList();
      _restaurantsByCategory[categoryId] = list;
    } catch (e) {
      String message = 'فشل في تحميل مطاعم الفئة، حاول لاحقاً';
      if (e is DioException) {
        final data = e.response?.data;
        final serverMsg = (data is Map) ? (data['error']?['message'] ?? data['message']) : null;
        if (serverMsg is String && serverMsg.isNotEmpty) {
          message = serverMsg;
        }
        // Debug log
        // ignore: avoid_print
        print('Category fetch error: status=${e.response?.statusCode}, body=${e.response?.data}');
      } else {
        // ignore: avoid_print
        print('Category fetch error: $e');
      }
      _error = message;
      // Fallback to top rated list so the page isn't empty
      await _fetchTopRatedRandom();
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
      deliveryTime: (json['deliveryTime'] ?? '30-45').toString().replaceAll(' دقيقة', ''),
      deliveryFee: ((json['deliveryFee'] ?? 0) as num).toInt(),
      originalDeliveryFee: null,
      cuisine: '',
      discount: null,
      isFavorite: (json['isFavorite'] ?? false) as bool,
      isPromoted: (json['isTopRated'] ?? false) as bool,
      tags: const [],
      minimumOrder: ((json['minimumOrder'] ?? 0) as num).toInt(),
    );
  }

  Future<void> _loadBackendCategoryMap() async {
    try {
      final lang = Localizations.localeOf(context).languageCode;
      // use home/categories to get list only
      final res = await _dio.get('home/categories', queryParameters: {
        'lang': lang,
      });
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
    } catch (_) {
      // ignore; we can still show default top rated
    }
  }

  String? _resolveBackendCategoryId(String displayName) {
    // try exact match, case-insensitive
    if (_categoryNameToId.containsKey(displayName)) return _categoryNameToId[displayName];
    final lower = displayName.toLowerCase();
    for (final entry in _categoryNameToId.entries) {
      if (entry.key.toLowerCase() == lower) return entry.value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              'قسم الطعام',
              textAlign: TextAlign.start,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: theme.dividerColor, width: 1),
                ),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push(AppRoutes.searchPage);
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن مطاعم، مأكولات...',
                      hintStyle: TextStyle(
                        color: theme.hintColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.hintColor,
                        size: 24,
                      ),
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    child: Text(
                      'الأصناف',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16),
                 SizedBox(
  height: 120,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 0),
    itemCount: _categories.length,
    itemBuilder: (context, index) {
      final category = _categories[index];
      final isSelected = _selectedCategoryId == category.id;
      return GestureDetector(
        onTap: () async {
          HapticFeedback.mediumImpact();
          setState(() {
            _selectedCategoryId = isSelected ? '' : category.id;
            _selectedFilter = 'الأعلى تقييماً';
          });
          if (_selectedCategoryId.isEmpty) {
            _fetchTopRatedRandom();
          } else {
            // Resolve backend category id by name if we have a mapping
            if (_categoryNameToId.isEmpty) {
              await _loadBackendCategoryMap();
            }
            final resolvedId = _resolveBackendCategoryId(category.name);
            if (resolvedId != null && resolvedId.isNotEmpty) {
              _selectedCategoryId = resolvedId;
              _fetchByCategory(resolvedId);
            } else {
              // Show a friendly message and revert selection
              _selectedCategoryId = '';
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('هذه الفئة غير متاحة حالياً')),
                );
              }
              _fetchTopRatedRandom();
            }
          }
        },
        child: Container(
          width: 120, // نفس العرض زي الأول
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: isSelected ? 8 : 4,
                shadowColor: Theme.of(context)
                    .shadowColor
                    .withOpacity(isSelected ? 0.25 : 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60), // نص القطر = نصف الطول
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: 80, // عرض الكارد
                  height: 80, // الطول = العرض -> دايرة مظبوطة
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Image.asset(
                      category.image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    },
  ),
)

                  // SizedBox(
                  //   height: 120,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: const EdgeInsets.symmetric(horizontal: 0),
                  //     itemCount: _categories.length,
                  //     itemBuilder: (context, index) {
                  //       final category = _categories[index];
                  //       final isSelected = _selectedCategoryId == category.id;

                  //       return GestureDetector(
                  //         onTap: () {
                  //           HapticFeedback.mediumImpact();
                  //           setState(() {
                  //             _selectedCategoryId = isSelected
                  //                 ? ''
                  //                 : category.id;
                  //             _selectedFilter = 'الأعلى تقييماً';
                  //           });
                  //         },
                  //         child: Container(
                  //           width: 110,
                  //           // margin: const EdgeInsets.symmetric(horizontal: 6),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Card(
                  //                 elevation: isSelected ? 6 : 3,
                  //                 shadowColor: Theme.of(
                  //                   context,
                  //                 ).shadowColor.withOpacity(0.15),
                  //                 shape: RoundedRectangleBorder(
                  //                   // borderRadius: BorderRadius.circular(16),
                  //                   // side: BorderSide(
                  //                   //   color: Theme.of(context).dividerColor,
                  //                   //   width: 1.5,
                  //                   // ),
                  //                 ),
                  //                 clipBehavior: Clip.antiAlias,
                  //                 child: Container(
                  //                   width: double.infinity,
                  //                   height: 70,
                  //                   color: Theme.of(context).cardColor,
                  //                   child: Center(
                  //                     child: Image.asset(category.image),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 5),
                  //               Text(
                  //                 category.name,
                  //                 textAlign: TextAlign.center,
                  //                 style: Theme.of(context).textTheme.bodySmall
                  //                     ?.copyWith(
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Theme.of(
                  //                         context,
                  //                       ).colorScheme.onSurface,
                  //                     ),
                  //                 maxLines: 1,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),

                  // SizedBox(
                  //   height: 110,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     itemCount: _categories.length,
                  //     itemBuilder: (context, index) {
                  //       final category = _categories[index];

                  //       return GestureDetector(
                  //         onTap: () {
                  //           HapticFeedback.mediumImpact();
                  //           setState(() {
                  //             _selectedCategoryId =
                  //                 _selectedCategoryId == category.id
                  //                     ? ''
                  //                     : category.id;
                  //             _selectedFilter = 'الأعلى تقييماً';
                  //           });
                  //         },
                  //         child: Container(
                  //           width: 85,
                  //           margin: const EdgeInsets.symmetric(horizontal: 4),
                  //           decoration: BoxDecoration(
                  //             color: theme.cardColor,
                  //             borderRadius: BorderRadius.circular(20),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: theme.shadowColor.withOpacity(0.1),
                  //                 blurRadius: 8,
                  //                 offset: const Offset(0, 3),
                  //               ),
                  //             ],
                  //             border: Border.all(
                  //               color: _selectedCategoryId == category.id
                  //                   ? category.color
                  //                   : theme.dividerColor,
                  //               width: 1.5,
                  //             ),
                  //           ),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Container(
                  //                 padding: const EdgeInsets.all(12),
                  //                 decoration: BoxDecoration(
                  //                   color: category.color.withOpacity(0.1),
                  //                   borderRadius: BorderRadius.circular(12),
                  //                 ),
                  //                 child: Icon(
                  //                   category.icon,
                  //                   size: 28,
                  //                   color: category.color,
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 8),
                  //               Text(
                  //                 category.name,
                  //                 style: theme.textTheme.labelMedium?.copyWith(
                  //                   fontWeight: FontWeight.w600,
                  //                   color: theme.colorScheme.onSurface,
                  //                 ),
                  //                 textAlign: TextAlign.center,
                  //                 maxLines: 1,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterChip('الأعلى تقييماً'),
                  _buildFilterChip('الأسرع توصيلاً'),
                  _buildFilterChip('توصيل مجاني'),
                ],
              ),
            ),
            _loading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 64.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : (_error != null)
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 64.0),
                          child: Text(
                            _error!,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                : _filteredRestaurants.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu_rounded,
                            size: 80,
                            color: theme.hintColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لم يتم العثور على مطاعم',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.hintColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'حاول تعديل بحثك أو استكشف\nأصنافًا مختلفة.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.hintColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(
                        _filteredRestaurants.length,
                        (index) => _buildEnhancedRestaurantCard(
                          context,
                          _filteredRestaurants[index],
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterName) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilter == filterName;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedFilter = filterName;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor,
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          filterName,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedRestaurantCard(
    BuildContext context,
    Restaurant restaurant,
  ) {
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
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.restaurant, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('جاري فتح ${restaurant.name}...'),
                  ],
                ),
                backgroundColor: theme.primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
            // يمكنك هنا إضافة التوجيه لصفحة تفاصيل المطعم
            // context.push('${AppRoutes.restaurantDetails}/${restaurant.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'restaurant-${restaurant.id}',
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
                          Icon(Icons.star, color: Colors.amber, size: 16),
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

// Data Models (بدون تغيير)
class FoodCategory {
  final String id;
  final String name;
  final String image;

  FoodCategory({required this.id, required this.name, required this.image});
}

class Restaurant {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final int deliveryFee;
  final int? originalDeliveryFee;
  final String cuisine;
  final String? discount;
  final bool isFavorite;
  final bool isPromoted;
  final List<String> tags;
  final int minimumOrder;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    this.originalDeliveryFee,
    required this.cuisine,
    this.discount,
    required this.isFavorite,
    this.isPromoted = false,
    required this.tags,
    required this.minimumOrder,
  });
}
