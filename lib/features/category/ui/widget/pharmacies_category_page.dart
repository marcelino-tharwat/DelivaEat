import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliva_eat/features/category/data/model/category_item.dart';
import 'package:deliva_eat/features/category/data/model/restaurant.dart';
import 'package:deliva_eat/features/category/ui/category_page.dart';
import 'package:flutter/material.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

// هذا الملف يحتوي على صفحة الصيدليات الثابتة
class PharmaciesCategoriesPage extends StatefulWidget {
  const PharmaciesCategoriesPage({super.key, this.categoryId = ""});
  final String categoryId;
  @override
  State<PharmaciesCategoriesPage> createState() =>
      _PharmaciesCategoriesPageState();
}

class _PharmaciesCategoriesPageState extends State<PharmaciesCategoriesPage> {
  String _selectedLocalCategoryId = '';
  String _selectedFilter = 'الأعلى تقييماً';
  bool _loading = false; // Static data, no loading
  String? _error;
  List<Restaurant> _filteredRestaurants = [];

  late final List<Map<String, dynamic>> _offersData;

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

  final List<CategoryItem> _categories = [
    CategoryItem(id: '1', name: 'أدوية', image: "assets/images/medical.png"),
    CategoryItem(
      id: '2',
      name: 'مكملات غذائية',
      image: "assets/images/multy_vitamin.png",
    ),

    CategoryItem(
      id: '3',
      name: ' العناية الشخصية ',
      image: "assets/images/personal_care.png",
    ),
    CategoryItem(
      id: '4',
      name: 'مستحضرات تجميل',
      image: "assets/images/Cosmetics.png",
    ),
    CategoryItem(
      id: '5',
      name: 'العناية بالأم والطفل',
      image: "assets/images/Mother&Baby_Care.png",
    ),
    CategoryItem(
      id: '6',
      name: 'الأدوات الطبية',
      image: "assets/images/Medical_Equipment.png",
    ),
  ];

  final Map<String, List<Restaurant>> _restaurantsByCategory = {
    '__top__': [
      Restaurant(
        id: '1',
        name: 'صيدلية الأمل',
        image:
            'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=2069&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
        reviewsCount: 150,
        deliveryTime: '10-20',
        deliveryFee: 0,
        isFavorite: false,
        isPromoted: true,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
      Restaurant(
        id: '2',
        name: 'صيدلية الصحة',
        image:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?q=80&w=1974&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.6,
        reviewsCount: 120,
        deliveryTime: '15-25',
        deliveryFee: 5,
        isFavorite: true,
        isPromoted: false,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
      Restaurant(
        id: '3',
        name: 'صيدلية الرياض',
        image:
            'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=2069&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
        reviewsCount: 200,
        deliveryTime: '20-30',
        deliveryFee: 10,
        isFavorite: false,
        isPromoted: true,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
      Restaurant(
        id: '4',
        name: 'صيدلية النهضة',
        image:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?q=80&w=1974&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.5,
        reviewsCount: 90,
        deliveryTime: '25-35',
        deliveryFee: 0,
        isFavorite: false,
        isPromoted: false,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
    ],
    '1': [
      // أدوية
      Restaurant(
        id: '1',
        name: 'صيدلية الأمل',
        image:
            'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=2069&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
        reviewsCount: 150,
        deliveryTime: '10-20',
        deliveryFee: 0,
        isFavorite: false,
        isPromoted: true,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
      Restaurant(
        id: '2',
        name: 'صيدلية الصحة',
        image:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?q=80&w=1974&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.6,
        reviewsCount: 120,
        deliveryTime: '15-25',
        deliveryFee: 5,
        isFavorite: true,
        isPromoted: false,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
    ],
    '2': [
      // مستحضرات تجميل
      Restaurant(
        id: '3',
        name: 'صيدلية الرياض',
        image:
            'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=2069&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
        reviewsCount: 200,
        deliveryTime: '20-30',
        deliveryFee: 10,
        isFavorite: false,
        isPromoted: true,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
    ],
    '3': [
      // أدوات طبية
      Restaurant(
        id: '4',
        name: 'صيدلية النهضة',
        image:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?q=80&w=1974&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.5,
        reviewsCount: 90,
        deliveryTime: '25-35',
        deliveryFee: 0,
        isFavorite: false,
        isPromoted: false,
        minimumOrder: 0,
        cuisine: '',
        tags: [],
      ),
    ],
    '4': [], // فيتامينات - empty for example
  };

  void _updateAndFilterRestaurants() {
    List<Restaurant> sourceList;
    if (_selectedLocalCategoryId.isNotEmpty) {
      sourceList = _restaurantsByCategory[_selectedLocalCategoryId] ?? [];
    } else {
      sourceList = _restaurantsByCategory['__top__'] ?? [];
    }

    final restaurantsCopy = List<Restaurant>.from(sourceList);
    switch (_selectedFilter) {
      case 'الأعلى تقييماً':
        restaurantsCopy.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'الأسرع توصيلاً':
        restaurantsCopy.sort((a, b) {
          int timeA = int.tryParse(a.deliveryTime.split('-')[0].trim()) ?? 99;
          int timeB = int.tryParse(b.deliveryTime.split('-')[0].trim()) ?? 99;
          return timeA.compareTo(timeB);
        });
        break;
      case 'توصيل مجاني':
        _filteredRestaurants = restaurantsCopy
            .where((r) => r.deliveryFee == 0)
            .toList();
        return;
    }
    _filteredRestaurants = restaurantsCopy;
  }

  @override
  void initState() {
    super.initState();
    _selectedLocalCategoryId = widget.categoryId;
    _initializeData();
  }

  Future<void> _initializeData() async {
    // No API calls, just set data
    _updateAndFilterRestaurants();
  }

  void _handleCategoryTap(String tappedLocalId) {
    final isCurrentlySelected = _selectedLocalCategoryId == tappedLocalId;

    if (isCurrentlySelected) {
      // إلغاء التحديد والعودة للأعلى تقييماً
      setState(() {
        _selectedLocalCategoryId = '';
        _selectedFilter = 'الأعلى تقييماً';
      });
      _updateAndFilterRestaurants();
    } else {
      // تحديد فئة جديدة
      setState(() {
        _selectedLocalCategoryId = tappedLocalId;
        _selectedFilter = 'الأعلى تقييماً';
      });
      _updateAndFilterRestaurants();
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
      // استخدم const هنا
      filters: [l10n.highestRated, l10n.fastestDelivery, l10n.freeDelivery],
      selectedFilter: _selectedFilter,
      isLoading: _loading,
      errorMessage: _error,
      onCategorySelected: _handleCategoryTap,
      onFilterSelected: (filter) {
        setState(() {
          _selectedFilter = filter;
          _updateAndFilterRestaurants();
        });
      },
      onRetry: () {
        // Since static, just reload
        _updateAndFilterRestaurants();
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
