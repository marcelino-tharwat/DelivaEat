import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/category/data/model/category_item.dart';
import 'package:deliva_eat/features/category/data/model/restaurant.dart';
import 'package:deliva_eat/features/category/ui/category_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

// هذا الملف يحتوي على صفحة الصيدليات الثابتة
class PharmaciesCategoriesPage extends StatefulWidget {
  const PharmaciesCategoriesPage({super.key, this.categoryId = ""});
  final String categoryId;
  @override
  State<PharmaciesCategoriesPage> createState() =>
      _PharmaciesCategoriesPageState();
}

// Helpers
Restaurant _mapApiToRestaurant(Map<String, dynamic> json) {
  final nameAr = (json['nameAr'] ?? '') as String;
  final name = (json['name'] ?? '') as String;
  final isArabic = WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ar';
  return Restaurant(
    id: (json['_id'] ?? '').toString(),
    name: isArabic && nameAr.isNotEmpty ? nameAr : name,
    image: (json['image'] ?? '') as String,
    rating: ((json['rating'] ?? 0) as num).toDouble(),
    reviewsCount: ((json['reviewCount'] ?? 0) as num).toInt(),
    deliveryTime: (json['deliveryTime'] ?? '30-45').toString().replaceAll(' دقيقة', ''),
    deliveryFee: ((json['deliveryFee'] ?? 0) as num).toInt(),
    isFavorite: (json['isFavorite'] ?? false) as bool,
    isPromoted: (json['isTopRated'] ?? false) as bool,
    minimumOrder: ((json['minimumOrder'] ?? 0) as num).toInt(),
    cuisine: '',
    tags: const [],
  );
}

class _PharmaciesCategoriesPageState extends State<PharmaciesCategoriesPage> {
  String _selectedLocalCategoryId = '';
  String _selectedBackendCategoryId = '';
  String _selectedFilter = '';
  bool _loading = true;
  String? _error;
  List<Restaurant> _filteredRestaurants = [];

  final Map<String, String> _categoryNameToId = {};
  String _pharmaciesRootId = '';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  List<Map<String, dynamic>> _getOffersData(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'title': l10n.discount20OnMedicines,
        'subtitle': l10n.useCodePharma20,
        'image':
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'color': Colors.blue,
      },
      {
        'title': l10n.freeDeliveryOnMedicines,
        'subtitle': l10n.forAllParticipatingPharmacies,
        'image':
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?q=80&w=1974&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'color': Colors.green,
      },
      {
        'title': l10n.offersOnCosmetics,
        'subtitle': l10n.discoverOurNewOffers,
        'image':
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'color': Colors.purple,
      },
    ];
  }

  final List<CategoryItem> _categories = const [
    CategoryItem(id: '1', name: 'أدوية', image: "assets/images/medical.png"),
    CategoryItem(id: '2', name: 'مكملات غذائية', image: "assets/images/multy_vitamin.png"),
    CategoryItem(id: '3', name: 'العناية الشخصية', image: "assets/images/personal_care.png"),
    CategoryItem(id: '4', name: 'مستحضرات تجميل', image: "assets/images/Cosmetics.png"),
    CategoryItem(id: '5', name: 'العناية بالأم والطفل', image: "assets/images/Mother&Baby_Care.png"),
    CategoryItem(id: '6', name: 'الأدوات الطبية', image: "assets/images/Medical_Equipment.png"),
  ];

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
        _filteredRestaurants = restaurantsCopy.where((r) => r.deliveryFee == 0).toList();
        return;
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
      // Normalize incoming id (may be a slug like 'pharmacies')
      if (_selectedBackendCategoryId.isNotEmpty) {
        final normalized = _normalizeBackendCategoryId(_selectedBackendCategoryId);
        _selectedBackendCategoryId = normalized ?? _selectedBackendCategoryId;
      }

      if (_selectedBackendCategoryId.isEmpty) {
        await _resolvePharmaciesRootId();
        await _fetchTopPharmacies();
      } else {
        _updateLocalCategoryFromBackendId(_selectedBackendCategoryId);
        await _fetchByCategory(_selectedBackendCategoryId);
      }
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _normalizeBackendCategoryId(String idOrName) {
    final s = idOrName.trim();
    // If it's a 24-hex, consider it ObjectId
    final hex24 = RegExp(r'^[0-9a-fA-F]{24}$');
    if (hex24.hasMatch(s)) return s;
    // Try exact map hit (both en/ar names were loaded)
    if (_categoryNameToId.containsKey(s)) return _categoryNameToId[s];
    // Try case-insensitive by name
    final lower = s.toLowerCase();
    for (final entry in _categoryNameToId.entries) {
      if (entry.key.toLowerCase() == lower) return entry.value;
    }
    // Common slugs
    const candidates = ['pharmacies', 'pharmacy', 'صيدليات'];
    for (final c in candidates) {
      final id = _categoryNameToId[c];
      if (id != null && id.isNotEmpty) return id;
    }
    return null;
  }

  Future<void> _resolvePharmaciesRootId() async {
    // Try common exact names first (both EN/AR)
    final exactCandidates = [
      'Pharmacies', 'Pharmacy', 'Pharma',
      'صيدليات', 'الصيدليات', 'صيدلية',
    ];
    for (final c in exactCandidates) {
      final id = _categoryNameToId[c];
      if (id != null && id.isNotEmpty) {
        _pharmaciesRootId = id;
        return;
      }
    }

    // Fuzzy contains match (case-insensitive)
    String? fuzzy;
    for (final entry in _categoryNameToId.entries) {
      final k = entry.key.toLowerCase();
      if (k.contains('pharm') || k.contains('صيد')) {
        fuzzy = entry.value;
        break;
      }
    }
    if (fuzzy != null) {
      _pharmaciesRootId = fuzzy;
      return;
    }

    // Fallback: use a known subcategory as root if present (Medicines / أدوية)
    final subFallbacks = ['Medicines', 'أدوية'];
    for (final c in subFallbacks) {
      final id = _categoryNameToId[c];
      if (id != null && id.isNotEmpty) {
        _pharmaciesRootId = id;
        return;
      }
    }

    // Final fallback remains empty; callers should handle gracefully
    _pharmaciesRootId = '';
  }

  Future<void> _fetchTopPharmacies() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      // Mirror Food: use /home/restaurants type=topRated and constrain by Pharmacies root
      final res = await _dio.get(
        ApiConstant.restaurantsUrl,
        queryParameters: {
          'type': 'topRated',
          'limit': 20,
          'lang': lang,
          if (_pharmaciesRootId.isNotEmpty) 'categoryId': _pharmaciesRootId,
        },
      );
      final List data = (res.data?['data'] ?? []) as List;
      final list = data.map((e) => _mapApiToRestaurant(e as Map<String, dynamic>)).toList();
      list.shuffle();
      _restaurantsByCategory['__top__'] = list;
    } catch (e) {
      _error = 'فشل في تحميل الصيدليات';
    } finally {
      final l10n = AppLocalizations.of(context)!;
      if (_selectedFilter.isEmpty) {
        _selectedFilter = l10n.highestRated;
      }
      _updateAndFilterRestaurants(l10n);
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
        ApiConstant.restaurantsByCategoryUrl,
        queryParameters: {
          'categoryId': categoryId,
          'limit': 50,
          'lang': lang,
          'sort': 'topRated',
          'random': 'true',
        },
      );
      final List data = (res.data?['data'] ?? []) as List;
      final list = data.map((e) => _mapApiToRestaurant(e as Map<String, dynamic>)).toList();
      _restaurantsByCategory[categoryId] = list;
    } catch (e) {
      String message = 'فشل في تحميل صيدليات الفئة';
      if (e is DioException) {
        final data = e.response?.data;
        final serverMsg = (data is Map)
            ? (data['error']?['message'] ?? data['message'])
            : null;
        if (serverMsg is String && serverMsg.isNotEmpty) message = serverMsg;
      }
      _error = message;
      await _fetchTopPharmacies();
    } finally {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        if (_selectedFilter.isEmpty) {
          _selectedFilter = l10n.highestRated;
        }
        _updateAndFilterRestaurants(l10n);
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadBackendCategoryMap() async {
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final res = await _dio.get(
        ApiConstant.categoriesUrl,
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
          (cat) => cat.name.trim().toLowerCase() == categoryName.trim().toLowerCase(),
          orElse: () => const CategoryItem(id: '', name: '', image: ''),
        );
        if (matchingCategory.id.isNotEmpty && mounted) {
          setState(() => _selectedLocalCategoryId = matchingCategory.id);
        }
        break;
      }
    }
  }

  String? _resolveBackendCategoryId(String displayName) {
    if (_categoryNameToId.containsKey(displayName)) return _categoryNameToId[displayName];
    final lower = displayName.trim().toLowerCase();
    for (final entry in _categoryNameToId.entries) {
      if (entry.key.trim().toLowerCase() == lower) return entry.value;
    }
    return null;
  }

  void _handleCategoryTap(String tappedLocalId) async {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) return; // prevent double taps while loading
    final isCurrentlySelected = _selectedLocalCategoryId == tappedLocalId;

    if (isCurrentlySelected) {
      setState(() {
        _selectedLocalCategoryId = '';
        _selectedBackendCategoryId = '';
        _selectedFilter = l10n.highestRated;
        _error = null;
      });
      await _resolvePharmaciesRootId();
      _fetchTopPharmacies();
    } else {
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
          _error = null;
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
    return ReusableCategoryLayout(
      pageTitle: l10n.pharmaciesSectionTitle,
      searchHintText: l10n.searchPharmaciesHint,
      offers: _getOffersData(context),
      categories: _categories,
      selectedCategoryId: _selectedLocalCategoryId,
      filters: [l10n.highestRated, l10n.fastestDelivery, l10n.freeDelivery],
      selectedFilter: _selectedFilter.isEmpty ? l10n.highestRated : _selectedFilter,
      isLoading: _loading,
      errorMessage: _error,
      onCategorySelected: _handleCategoryTap,
      onSearchTap: () async {
        if (_pharmaciesRootId.isEmpty) await _resolvePharmaciesRootId();
        // Fallback to pharmacy root name if id not found so backend can resolve by name
        final pharmCategoryParam = _pharmaciesRootId.isNotEmpty ? _pharmaciesRootId : 'صيدليات';
        context.push(AppRoutes.searchPage, extra: {
          'categoryId': pharmCategoryParam,
          'type': 'foods',
          'categoryType': 'pharmacies',
        });
      },
      onFilterSelected: (filter) {
        setState(() {
          _selectedFilter = filter;
          _updateAndFilterRestaurants(l10n);
        });
      },
      onRetry: () {
        setState(() { _error = null; });
        if (_selectedBackendCategoryId.isNotEmpty) {
          _fetchByCategory(_selectedBackendCategoryId);
        } else {
          _fetchTopPharmacies();
        }
      },
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        // بناء الويدجت الجديدة بدلاً من الدالة
        return _PharmacyCard(restaurant: _filteredRestaurants[index]);
      },
    );
  }
}

// --- تم فصل كارت الصيدلية في ويدجت خاصة بها ---
// هذا أفضل من ناحية التنظيم والأداء
class _PharmacyCard extends StatelessWidget {
  const _PharmacyCard({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      // استخدام const للمحتويات الثابتة
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to pharmacy details if needed
          },
          // تم تحويل Padding إلى const لأنه لن يتغير
          child: Padding(
            padding: const EdgeInsets.all(
              12.0,
            ), // تعديل بسيط للمسافة لتجنب التصاق الصورة بالحافة
            child: Row(
              children: [
                Hero(
                  tag: 'pharmacy-card-${restaurant.id}',
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
                            Icons.local_pharmacy,
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
                              : l10n.deliveryFee(
                                  restaurant.deliveryFee.toString(),
                                ),
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
                // استخدام const للأيقونة
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
