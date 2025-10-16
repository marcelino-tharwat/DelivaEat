import 'dart:async';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/home/ui/widget/home_skeleton_loader.dart';
import 'package:deliva_eat/features/home/ui/widget/SectionHeader.dart';
import 'package:deliva_eat/features/home/ui/widget/custom_botton_navigation_bar.dart';
// import removed: food_card_list.dart
import 'package:deliva_eat/features/home/ui/widget/home_header.dart';
import 'package:deliva_eat/features/home/ui/widget/show_notifications_bottom_sheet.dart';
import 'package:deliva_eat/features/home/ui/widget/top_rated_resturant_list.dart';
// import removed: favorite_restaurant_list.dart
import 'package:deliva_eat/features/home/ui/widget/favorite_mixed_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:deliva_eat/features/home/cubit/home_cubit.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';

class FoodDeliveryHomePage extends StatefulWidget {
  const FoodDeliveryHomePage({super.key});

  @override
  FoodDeliveryHomePageState createState() => FoodDeliveryHomePageState();
}

class FoodDeliveryHomePageState extends State<FoodDeliveryHomePage>
    with TickerProviderStateMixin {
  final PageController pageController = PageController(viewportFraction: 0.9);
  Timer? _offersTimer;
  int _currentSlide = 0;

  late final PageController _categoriesPageController;
  Timer? _categoriesTimer;
  int _currentCategoryPage = 0;

  int _selectedNavIndex = 0;

  // سيتم ملء هذه القوائم من cubit والترجمات
  List<Map<String, String>> _staticCategories = [];

  @override
  void initState() {
    super.initState();
    _categoriesPageController = PageController(
      viewportFraction: 0.28,
      initialPage: _currentCategoryPage,
    );
    // تأكد من أن البيانات تُطلب مرة واحدة عند تحميل الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStaticData();
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      context.read<HomeCubit>().getHomeData(lang: isArabic ? 'ar' : 'en');
      _startAutoSlide();
      _startCategoriesAutoSlide();
    });
  }

  void _initializeStaticData() {
    // هذه الدالة تضمن أن البيانات الثابتة (مثل أيقونات الفئات) تُهيأ مرة واحدة فقط
    if (_staticCategories.isNotEmpty) return;

    setState(() {
      _staticCategories.addAll(
        [
          {
            'id': 'food',
            'name': 'Food',
            'image': "assets/images/food.png",
          },
          {
            'id': 'grocery',
            'name': 'Grocery',
            'image': "assets/images/groceries.png",
          },
          {
            'id': 'markets',
            'name': 'Markets',
            'image': "assets/images/markets.png",
          },
          {
            'id': 'pharmacies',
            'name': 'Pharmacies',
            'image': "assets/images/pharma2.png",
          },
          {
            'id': 'gifts',
            'name': 'Gifts & Donate',
            'image': "assets/images/gifts.png",
          },
          {
            'id': 'stores',
            'name': 'Stores',
            'image': "assets/images/markets.png",
          },
        ].map((e) => Map<String, String>.from(e)),
      );
    });
  }

  void _startAutoSlide() {
    _offersTimer?.cancel(); // إلغاء التايمر القديم أولاً
    _offersTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (pageController.hasClients) {
        final homeState = context.read<HomeCubit>().state;
        if (homeState is HomeSuccess && homeState.offers.isNotEmpty) {
          _currentSlide = (_currentSlide + 1) % homeState.offers.length;
          pageController.animateToPage(
            _currentSlide,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  void _startCategoriesAutoSlide() {
    _categoriesTimer?.cancel();
    _categoriesTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_categoriesPageController.hasClients &&
          _staticCategories.length > 3) {
        _currentCategoryPage++;
        if (_currentCategoryPage >= _staticCategories.length - 2) {
          _currentCategoryPage = 0;
          _categoriesPageController.jumpToPage(0);
        }
        _categoriesPageController.animateToPage(
          _currentCategoryPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _offersTimer?.cancel();
    _categoriesTimer?.cancel();
    pageController.dispose();
    _categoriesPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const HomeSkeletonLoader();
          }
          if (state is HomeError) {
            return _buildErrorState(state, context);
          }

          if (state is HomeSuccess) {
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';
            final offers = state.offers
                .map(
                  (offer) => {
                    'title': isArabic ? offer.titleAr : offer.title,
                    'subtitle': isArabic ? offer.subtitleAr : offer.subtitle,
                    'color':
                        _parseHexColor(offer.color) ?? const Color(0xFFFF6B35),
                    'icon': offer.icon.isNotEmpty ? offer.icon : '🍔',
                    'image': offer.image,
                    'discount': offer.discount,
                  },
                )
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    onNotificationTap: _showNotificationsBottomSheet,
                    onSeeAllTap: _handleSeeAll,
                    categories: _staticCategories,
                    categoriesPageController: _categoriesPageController,
                    onCategoryTap: _handleCategoryTap,
                    offers: offers,
                    offersPageController: pageController,
                    currentOfferSlide: _currentSlide,
                    onOfferPageChanged: (index) =>
                        setState(() => _currentSlide = index),
                    onOfferTap: _handleOfferTap,
                  ),
                  Transform.translate(
                    offset: Offset(0, -30.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          SectionHeader(
                            title: AppLocalizations.of(context)!.favorites,
                            icon: Icons.favorite,
                            iconColor: const Color(0xFFFFD93D),
                            onSeeAllTap: _handleSeeAll,
                          ),
                          FavoriteMixedList(
                            restaurants: state.favoriteRestaurants,
                            foods: state.favoriteFoods,
                            onRestaurantTap: _handleRestaurantTap,
                            onFoodTap: _handleFoodCardTap,
                            onToggleRestaurantFavorite: _handleToggleFavorite,
                            onToggleFoodFavorite: _handleToggleFoodFavorite,
                          ),
                          SizedBox(height: 8.h),
                          SectionHeader(
                            title: AppLocalizations.of(
                              context,
                            )!.topRatedRestaurants,
                            onSeeAllTap: _handleSeeAll,
                          ),
                          TopRatedRestaurantsList(
                            restaurants: state.topRatedRestaurants,
                            onRestaurantDetailTap: _handleRestaurantDetailTap,
                            onViewMenuTap: _handleViewMenu,
                            // CHANGED: Added toggle favorite handler
                            onToggleFavorite: _handleToggleFavorite,
                          ),
                          SizedBox(height: 0.h),
                          // SectionHeader(
                          //   title: AppLocalizations.of(context)!.bestSelling,
                          //   onSeeAllTap: _handleSeeAll,
                          // ),
                          // FoodCardList(
                          //   foods: state.bestSellingFoods,
                          //   onFoodCardTap: _handleFoodCardTap,
                          //   // CHANGED: Added toggle favorite handler
                          //   onToggleFavorite: _handleToggleFoodFavorite,
                          // ),
                          // SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          // This case should ideally not be reached if states are handled correctly
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedNavIndex,
        onItemSelected: (index) {
          setState(() => _selectedNavIndex = index);
          HapticFeedback.lightImpact();
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildErrorState(HomeError state, BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 48.sp, color: context.colors.primary),
            SizedBox(height: 12.h),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: context.textStyles.titleMedium,
            ),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              onPressed: () => context.read<HomeCubit>().getHomeData(
                lang: isArabic ? 'ar' : 'en',
              ),
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text(
                AppLocalizations.of(context)!.resend,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Handlers ---

  void _handleFoodCardTap(String name, int index) {
    HapticFeedback.lightImpact();
    final state = context.read<HomeCubit>().state;
    if (state is HomeSuccess && index < state.favoriteFoods.length) {
      final food = state.favoriteFoods[index];
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      final displayName = (isArabic ? food.nameAr : food.name) ?? 'طعام';
      final priceStr = food.price?.toStringAsFixed(0) ?? '0';
      context.push(
        AppRoutes.productDetailsPage,
        extra: {
          'foodId': food.id.toString(),
          'title': displayName,
          'image': food.image,
          'price': priceStr,
          'isFavorite': food.isFavorite ?? false,
        },
      );
    }
  }

  void _handleOfferTap(Map<String, dynamic> offer) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.offerTappedSnackbar(offer['title']),
        ),
      ),
    );
  }

  void _handleCategoryTap(Map<String, dynamic> category) {
    HapticFeedback.lightImpact();
    final String categoryId = (category['id'] ?? '').toString();

    switch (categoryId) {
      case 'food':
        context.push(AppRoutes.categoryPage, extra: {'categoryType': 'food'});
        break;
      case 'pharmacies':
        context.push(
          AppRoutes.pharmaciesPage,
          extra: {'id': categoryId, 'categoryType': 'pharmacies'},
        );
        break;
      case 'grocery':
        context.push(
          AppRoutes.groceryPage,
          extra: {'id': categoryId, 'categoryType': 'grocery'},
        );
        break;
      case 'markets':
        context.push(
          AppRoutes.marketsCategoryPage,
          extra: {'categoryId': categoryId, 'categoryType': 'markets'},
        );
        break;
      case 'gifts':
      case 'stores':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('قسم "${category['name']}" سيتم إضافته قريباً!'),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فئة غير معروفة')));
    }
  }

  Future<void> _handleRestaurantTap(String name, int index) async {
    HapticFeedback.lightImpact();
    final state = context.read<HomeCubit>().state;
    if (state is HomeSuccess) {
      if (index >= 0 && index < state.favoriteRestaurants.length) {
        final r = state.favoriteRestaurants[index];
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        final displayName = isArabic
            ? (r.nameAr ?? r.name)
            : (r.name ?? r.nameAr);
        // Navigate to RestaurantHomePage
        final result = await context.push(
          AppRoutes.restaurantPage,
          extra: {
            'restaurantId': r.id?.toString() ?? '',
            'restaurantName': (displayName ?? '').isEmpty
                ? 'المطعم'
                : displayName,
          },
        );
        if (result is Map) {
          final restaurantId = (result['restaurantId'] ?? '').toString();
          final lang = (result['lang'] ?? (isArabic ? 'ar' : 'en')).toString();
          final baseJson = (result['base'] as Map?)?.cast<String, dynamic>();
          final base = baseJson != null
              ? RestaurantModel.fromJson(baseJson)
              : null;
          if (restaurantId.isNotEmpty) {
            final curr = context.read<HomeCubit>().state;
            if (curr is HomeSuccess) {
              final merged = [
                ...curr.favoriteRestaurants,
                ...curr.topRatedRestaurants,
              ];
              final currentItem = merged.firstWhere(
                (rr) => rr.id == restaurantId,
                orElse: () => base ?? r,
              );
              final currentFav = currentItem.isFavorite ?? false;
              final returnedFav = (base?.isFavorite) ?? false;
              if (currentFav != returnedFav) {
                context.read<HomeCubit>().toggleFavorite(
                  restaurantId: restaurantId,
                  lang: lang,
                  baseOverride: base,
                );
              }
            }
          }
        }
      }
    }
  }

  // Handler for toggling restaurant favorite status (used by Favorite and Top Rated lists)
  void _handleToggleFavorite(String restaurantId) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    context.read<HomeCubit>().toggleFavorite(
      restaurantId: restaurantId,
      lang: isArabic ? 'ar' : 'en',
    );
  }

  // ADDED: Handler for toggling food favorite status
  void _handleToggleFoodFavorite(String foodId) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    context.read<HomeCubit>().toggleFoodFavorite(
      foodId: foodId,
      lang: isArabic ? 'ar' : 'en',
    );
  }

  Future<void> _handleRestaurantDetailTap(
    Map<String, dynamic> restaurant,
    int index,
  ) async {
    // Open RestaurantHomePage instead of menu page
    final id = (restaurant['id'] ?? '').toString();
    final name = (restaurant['name'] ?? '').toString();
    if (id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('معرف المطعم غير متوفر')));
      return;
    }
    final result = await context.push(
      AppRoutes.restaurantPage,
      extra: {
        'restaurantId': id,
        'restaurantName': name.isEmpty ? 'المطعم' : name,
      },
    );
    if (result is Map) {
      final restaurantId = (result['restaurantId'] ?? '').toString();
      final lang = (result['lang'] ?? 'ar').toString();
      final baseJson = (result['base'] as Map?)?.cast<String, dynamic>();
      final base = baseJson != null ? RestaurantModel.fromJson(baseJson) : null;
      if (restaurantId.isNotEmpty && base != null) {
        final curr = context.read<HomeCubit>().state;
        if (curr is HomeSuccess) {
          final merged = [
            ...curr.favoriteRestaurants,
            ...curr.topRatedRestaurants,
          ];
          final currentItem = merged.firstWhere(
            (r) => r.id == restaurantId,
            orElse: () => base,
          );
          final currentFav = currentItem.isFavorite ?? false;
          final returnedFav = base.isFavorite ?? false;
          if (currentFav != returnedFav) {
            context.read<HomeCubit>().toggleFavorite(
              restaurantId: restaurantId,
              lang: lang,
              baseOverride: base,
            );
          }
        }
      }
    }
  }

  Future<void> _handleViewMenu(Map<String, dynamic> restaurant) async {
    // Also open RestaurantHomePage for consistency
    final id = (restaurant['id'] ?? '').toString();
    final name = (restaurant['name'] ?? '').toString();
    if (id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('معرف المطعم غير متوفر')));
      return;
    }
    final result = await context.push(
      AppRoutes.restaurantPage,
      extra: {
        'restaurantId': id,
        'restaurantName': name.isEmpty ? 'المطعم' : name,
      },
    );
    if (result is Map) {
      final restaurantId = (result['restaurantId'] ?? '').toString();
      final lang = (result['lang'] ?? 'ar').toString();
      final baseJson = (result['base'] as Map?)?.cast<String, dynamic>();
      final base = baseJson != null ? RestaurantModel.fromJson(baseJson) : null;
      if (restaurantId.isNotEmpty) {
        final curr = context.read<HomeCubit>().state;
        if (curr is HomeSuccess && base != null) {
          final merged = [
            ...curr.favoriteRestaurants,
            ...curr.topRatedRestaurants,
          ];
          final currentItem = merged.firstWhere(
            (r) => r.id == restaurantId,
            orElse: () => base,
          );
          final currentFav = currentItem.isFavorite ?? false;
          final returnedFav = base.isFavorite ?? false;
          if (currentFav != returnedFav) {
            context.read<HomeCubit>().toggleFavorite(
              restaurantId: restaurantId,
              lang: lang,
              baseOverride: base,
            );
          }
        }
      }
    }
  }

  void _handleSeeAll(String section) {
    HapticFeedback.lightImpact();
    final appLocalizations = AppLocalizations.of(context)!;
    if (section == appLocalizations.favorites) {
      final homeState = context.read<HomeCubit>().state;
      if (homeState is HomeSuccess) {
        final favoriteFoods = homeState.favoriteFoods;
        context.push(
          AppRoutes.favoritesPage,
          extra: {
            'favoriteRestaurants': homeState.favoriteRestaurants,
            'favoriteFoods': favoriteFoods,
          },
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('عرض المزيد من: $section')));
    }
  }

  void _handleNavigation(int index) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final pages = [
      appLocalizations.homePageTitle,
      appLocalizations.ordersTitle,
      appLocalizations.offersTitle,
      appLocalizations.accountTitle,
    ];
    if (index != _selectedNavIndex) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('انتقال إلى: ${pages[index]}')));
    }
  }

  void _showNotificationsBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationsBottomSheet(),
    );
  }
}

// --- Helpers ---
extension _HomePageHelpers on FoodDeliveryHomePageState {
  void _openRestaurantMenu(Map<String, dynamic> restaurant) {
    HapticFeedback.lightImpact();
    final id = (restaurant['id'] ?? restaurant['_id'])?.toString() ?? '';
    final name = (restaurant['name'] ?? '')?.toString() ?? '';

    if (id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('معرف المطعم غير متوفر')));
      return;
    }

    context.pushNamed(
      AppRoutes.restaurantMenuPage,
      pathParameters: {'restaurantId': id},
      extra: name.isEmpty ? 'القائمة' : name,
    );
  }

  Color? _parseHexColor(String hex) {
    try {
      String value = hex.trim().replaceAll('#', '');
      if (value.length == 6) value = 'FF$value';
      return Color(int.parse(value, radix: 16));
    } catch (_) {
      return null;
    }
  }
}
