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
import 'package:deliva_eat/core/network/dio_factory.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/restaurant/ui/widgets/restaurant_skeleton_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

class _RestaurantHomePageState extends State<RestaurantHomePage>
    with AutomaticKeepAliveClientMixin {
  bool _isFavorite = false;
  bool _loading = true;
  String? _error;

  late final Dio _dio;
  Map<String, dynamic>? _restaurant;
  List<String> _tabs = [];
  List<String> _badges = [];

  String selectedCategory = '';
  final Map<String, List<Map<String, dynamic>>> _itemsByTab = {};
  final Map<String, bool> _loadingTabs = {};
  late final ScrollController _scrollController;
  List<GlobalKey> _categoryKeys = [];

  @override
  bool get wantKeepAlive => true;

  Future<void> _toggleFavorite() async {
    final newVal = !_isFavorite;
    setState(() => _isFavorite = newVal);

    if (!mounted) return;

    final lang = Localizations.localeOf(context).languageCode;
    final m = _restaurant ?? <String, dynamic>{};
    final model = _createRestaurantModel(m, !newVal);

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
    } catch (_) {}

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
          if (mounted) setState(() => _isFavorite = serverFav);
        } else {
          if (mounted) {
            setState(() => _isFavorite = !newVal);
            _showSnackBar('Failed to update favorite');
          }
        }
      } catch (_) {
        if (mounted) {
          setState(() => _isFavorite = !newVal);
          _showSnackBar('Connection error while updating favorite');
        }
      }
    }
  }

  RestaurantModel _createRestaurantModel(Map<String, dynamic> m, bool isFav) {
    return RestaurantModel(
      id: (m['_id']?.toString() ?? widget.restaurantId),
      name: (m['name'] ?? '') as String,
      nameAr: (m['nameAr'] ?? m['name'] ?? '') as String,
      description:
          (m['description'] as String?) ?? (m['descriptionAr'] as String?),
      descriptionAr:
          (m['descriptionAr'] as String?) ?? (m['description'] as String?),
      image: (m['image'] ?? '') as String,
      coverImage: m['coverImage'] as String?,
      rating: (m['rating'] is num) ? (m['rating'] as num).toDouble() : null,
      reviewCount: m['reviewCount'] is int
          ? m['reviewCount'] as int
          : int.tryParse('${m['reviewCount'] ?? ''}'),
      deliveryTime: m['deliveryTime']?.toString(),
      deliveryFee: (m['deliveryFee'] is num)
          ? (m['deliveryFee'] as num).toDouble()
          : null,
      minimumOrder: (m['minimumOrder'] is num)
          ? (m['minimumOrder'] as num).toDouble()
          : null,
      isOpen: m['isOpen'] as bool?,
      isActive: m['isActive'] as bool?,
      isFavorite: isFav,
      isTopRated: m['isTopRated'] as bool?,
      address: m['address'] as String?,
      phone: m['phone'] as String?,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _dio = DioFactory.getDio();

    // تحميل باقي التابات عندما يكون المستخدم Idle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          for (final tab in _tabs) {
            if (!_itemsByTab.containsKey(tab) && _loadingTabs[tab] != true) {
              unawaited(_fetchItemsForTab(tab));
            }
          }
        }
      });
    });
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
      _isFavorite = (_restaurant?['isFavorite'] ?? false) == true;

      final l10n = AppLocalizations.of(context)!;
      _tabs = _buildLocalizedTabs(data, l10n);

      final List badgesRaw = (data['badges'] ?? []) as List;
      _badges = badgesRaw.map((e) => e.toString().toLowerCase()).toList();

      _categoryKeys = List.generate(_tabs.length, (_) => GlobalKey());

      if (_tabs.isNotEmpty) {
        selectedCategory = _tabs.first;

        // حمّل التاب الأول
        await _fetchItemsForTab(selectedCategory);

        // حمّل التاب الثاني في الخلفية
        if (_tabs.length > 1) {
          unawaited(_fetchItemsForTab(_tabs[1]));
        }
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _error = l10n.failedToLoadRestaurants;
      _tabs = _getDefaultTabs(l10n);
      _categoryKeys = List.generate(_tabs.length, (_) => GlobalKey());
      selectedCategory = _tabs.first;
      unawaited(_fetchItemsForTab(selectedCategory));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<String> _buildLocalizedTabs(
    Map<String, dynamic> data,
    AppLocalizations l10n,
  ) {
    final List tabsRaw = (data['tabs'] ?? []) as List;
    var tabs = tabsRaw.map((e) => e.toString()).toList();

    tabs.removeWhere(
      (t) => t.toLowerCase() == 'trending' || t.toLowerCase() == 'free',
    );

    final localizedRest = tabs.map((t) {
      final tl = t.toLowerCase();
      if (tl == 'soup') return l10n.categorySoup;
      if (tl == 'appetizers') return l10n.categoryAppetizers;
      if (tl == 'pasta') return l10n.categoryPasta;
      if (tl == 'drinks') return l10n.categoryDrinks;
      return t;
    }).toList();

    final result = [l10n.categoryTrending, l10n.categoryFree, ...localizedRest];
    return result.isEmpty ? _getDefaultTabs(l10n) : result;
  }

  List<String> _getDefaultTabs(AppLocalizations l10n) {
    return [
      l10n.categoryTrending,
      l10n.categoryFree,
      l10n.categorySoup,
      l10n.categoryAppetizers,
      l10n.categoryPasta,
      l10n.categoryDrinks,
    ];
  }

  Future<void> _fetchItemsForTab(String tab) async {
    if (_loadingTabs[tab] == true) return;

    setState(() => _loadingTabs[tab] = true);

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
    } finally {
      setState(() => _loadingTabs[tab] = false);
    }
  }

  void _prefetchAdjacentTabs(String currentTab) {
    final currentIndex = _tabs.indexOf(currentTab);
    if (currentIndex == -1) return;

    // حمّل التاب التالي
    if (currentIndex + 1 < _tabs.length) {
      final nextTab = _tabs[currentIndex + 1];
      if (!_itemsByTab.containsKey(nextTab) && _loadingTabs[nextTab] != true) {
        _fetchItemsForTab(nextTab);
      }
    }

    // حمّل التاب السابق
    if (currentIndex - 1 >= 0) {
      final prevTab = _tabs[currentIndex - 1];
      if (!_itemsByTab.containsKey(prevTab) && _loadingTabs[prevTab] != true) {
        _fetchItemsForTab(prevTab);
      }
    }
  }

  String _mapDisplayTabToApi(String tab) {
    final t = tab.toLowerCase();
    final l10n = AppLocalizations.of(context)!;

    final mapping = {
      l10n.categoryTrending.toLowerCase(): 'Trending',
      l10n.categoryFree.toLowerCase(): 'Free',
      l10n.categorySoup.toLowerCase(): 'Soup',
      l10n.categoryAppetizers.toLowerCase(): 'Appetizers',
      l10n.categoryPasta.toLowerCase(): 'Pasta',
      l10n.categoryDrinks.toLowerCase(): 'Drinks',
    };

    return mapping[t] ?? tab;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatPrice(dynamic value) {
    if (value == null) return '';
    try {
      final numVal = value is num
          ? value.toDouble()
          : double.tryParse(value.toString()) ?? 0.0;
      return 'EGP ${numVal.toStringAsFixed(numVal % 1 == 0 ? 0 : 2)}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          final lang = Localizations.localeOf(context).languageCode;
          final m = _restaurant ?? <String, dynamic>{};
          final base = _createRestaurantModel(m, _isFavorite);

          Navigator.of(context).pop({
            'restaurantId': widget.restaurantId,
            'lang': lang,
            'isFavorite': _isFavorite,
            'base': base.toJson(),
          });
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: MobileOnlyLayout(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (_loading)
                const SliverToBoxAdapter(child: RestaurantSkeletonLoader())
              else
                _buildHeaderWrapper(colorScheme, l10n),

              _buildCategoryTabs(colorScheme),

              ..._buildFoodSections(colorScheme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderWrapper(ColorScheme colorScheme, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: _RestaurantHeader(
        restaurant: _restaurant,
        isFavorite: _isFavorite,
        onBackPressed: () {
          final lang = Localizations.localeOf(context).languageCode;
          final m = _restaurant ?? <String, dynamic>{};
          final base = _createRestaurantModel(m, _isFavorite);

          Navigator.of(context).pop({
            'restaurantId': widget.restaurantId,
            'lang': lang,
            'isFavorite': _isFavorite,
            'base': base.toJson(),
          });
        },
        onFavoriteToggle: _toggleFavorite,
        l10n: l10n,
        colorScheme: colorScheme,
      ),
    );
  }

  Widget _buildCategoryTabs(ColorScheme colorScheme) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 40.h),
        decoration: BoxDecoration(color: colorScheme.surface),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              itemCount: _tabs.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Icon(Icons.menu, size: 24.sp);
                }
                return _buildCategoryTab(_tabs[index - 1]);
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFoodSections(
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return _tabs.asMap().entries.expand((tabEntry) {
      final index = tabEntry.key;
      final category = tabEntry.value;

      return [
        SliverPersistentHeader(
          key: _categoryKeys[index],
          pinned: false,
          delegate: _CategoryHeaderDelegate(category),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, idx) {
              final items = _itemsByTab[category] ?? [];

              if (items.isEmpty) {
                return Container(
                  color: colorScheme.surface,
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    _error ?? 'لا توجد بيانات',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                );
              }

              final item = items[idx];
              final foodId = (item['_id'] ?? item['id'] ?? '').toString();

              return Container(
                color: colorScheme.surface,
                padding: EdgeInsets.only(
                  bottom: 16.h,
                  left: 16.w,
                  right: 16.w,
                  top: idx == 0 ? 2.h : 0,
                ),
                child: _FoodItemWidget(
                  title: (item['nameAr'] ?? item['name'] ?? '').toString(),
                  description:
                      (item['descriptionAr'] ?? item['description'] ?? '')
                          .toString(),
                  price: _formatPrice(item['price']),
                  imageUrl: (item['image'] ?? '').toString(),
                  foodId: foodId,
                  rating: (item['rating'] is num)
                      ? (item['rating'] as num).toDouble()
                      : double.tryParse('${item['rating'] ?? ''}'),
                  reviewCount: (item['reviewCount'] is int)
                      ? item['reviewCount'] as int
                      : int.tryParse('${item['reviewCount'] ?? ''}'),
                  colorScheme: colorScheme,
                ),
              );
            },
            childCount: (_itemsByTab[category] ?? []).isEmpty
                ? 1
                : (_itemsByTab[category] ?? []).length,
          ),
        ),
      ];
    }).toList();
  }

  void _scrollToCategory(String category) {
    final index = _tabs.indexOf(category);
    if (index != -1 && _categoryKeys[index].currentContext != null) {
      Scrollable.ensureVisible(
        _categoryKeys[index].currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildCategoryTab(String title) {
    final isSelected = title == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = title);

        if (!_itemsByTab.containsKey(title)) {
          _fetchItemsForTab(title);
        }

        // تحميل التابات المجاورة في الخلفية
        _prefetchAdjacentTabs(title);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCategory(title);
        });
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
}

// ============ Extracted Header Widget ============
class _RestaurantHeader extends StatelessWidget {
  final Map<String, dynamic>? restaurant;
  final bool isFavorite;
  final VoidCallback onBackPressed;
  final VoidCallback onFavoriteToggle;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  const _RestaurantHeader({
    required this.restaurant,
    required this.isFavorite,
    required this.onBackPressed,
    required this.onFavoriteToggle,
    required this.l10n,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Cover Image
        Container(
          height: 280.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                restaurant?['coverImage'] ??
                    restaurant?['image'] ??
                    'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Back Button
        Positioned(top: 50.h, left: 16.w, child: _buildBackButton()),

        // Favorite Button
        Positioned(top: 50.h, right: 16.w, child: _buildFavoriteButton()),

        // Logo
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
              child: CachedNetworkImage(
                imageUrl:
                    restaurant?['image'] ??
                    'https://placehold.co/160x160/png?text=Logo',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.restaurant, size: 40),
                ),
              ),
            ),
          ),
        ),

        // White Container
        Positioned(
          top: 260.h,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: SizedBox(height: 60.h),
          ),
        ),

        // Offers
        Positioned(top: 230.h, left: 0, right: 0, child: _buildOffers()),
      ],
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: onBackPressed,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.onSurface, width: 1.5.w),
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 20.sp,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: isFavorite ? const Color(0xFFFF6B6B) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4.r),
        ],
      ),
      child: InkWell(
        onTap: onFavoriteToggle,
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 26.sp,
          color: isFavorite ? Colors.white : colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildOffers() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xffFEF5F8),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer, color: Colors.pink, size: 20.sp),
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
                  Icon(Icons.local_offer, color: Colors.pink, size: 20.sp),
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
    );
  }
}

// ============ Food Item Widget ============
class _FoodItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final String foodId;
  final double? rating;
  final int? reviewCount;
  final ColorScheme colorScheme;

  const _FoodItemWidget({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.foodId,
    this.rating,
    this.reviewCount,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          AppRoutes.productDetailsPage,
          extra: {
            'foodId': foodId,
            'title': title,
            'image': imageUrl,
            'price': price,
            'rating': rating,
            'reviewCount': reviewCount,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
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
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 110.w,
                  height: 110.h,
                  fit: BoxFit.cover,
                  memCacheWidth: 220,
                  memCacheHeight: 220,
                  placeholder: (context, url) => Container(
                    width: 110.w,
                    height: 110.h,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, error, stackTrace) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
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

// ============ Category Header Delegate ============
class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String category;

  _CategoryHeaderDelegate(this.category);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      color: colorScheme.surface,
      child: Text(
        category,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface),
      ),
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

// ============ Helper Function ============
void unawaited(Future<void> future) {
  future.then((_) {}, onError: (_) {});
}
