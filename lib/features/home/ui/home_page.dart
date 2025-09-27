import 'dart:async';
import 'package:deliva_eat/features/home/ui/widget/SectionHeader.dart';
import 'package:deliva_eat/features/home/ui/widget/custom_botton_navigation_bar.dart';
import 'package:deliva_eat/features/home/ui/widget/food_card_list.dart';
import 'package:deliva_eat/features/home/ui/widget/home_header.dart';
import 'package:deliva_eat/features/home/ui/widget/show_notifications_bottom_sheet.dart';
import 'package:deliva_eat/features/home/ui/widget/top_rated_resturant_list.dart';
import 'package:deliva_eat/features/home/ui/widget/favorite_restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:deliva_eat/features/restaurant/ui/restaurant_menu_page.dart';
import 'package:deliva_eat/features/category/ui/category_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ أضفت المكتبة

import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:deliva_eat/features/home/cubit/home_cubit.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';

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

  final List<Map<String, dynamic>> _offers = [];
  final List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDataWithLocalizations();
      _startAutoSlide();
      _startCategoriesAutoSlide();
    });

    _categoriesPageController = PageController(
      viewportFraction: 0.28,
      initialPage: _currentCategoryPage,
    );
  }

  void _handleFoodCardTap(String name, int index) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اختيار: $name'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _initializeDataWithLocalizations() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    setState(() {
      _offers.addAll([
        {
          'title': appLocalizations.offerTodayTitle,
          'subtitle': appLocalizations.offerTodaySubtitle,
          'color': const Color(0xFFFF6B35),
          'icon': '🍔',
          'image': 'assets/offer_burger.png',
          'discount': '29',
        },
        {
          'title': appLocalizations.offerFreeDeliveryTitle,
          'subtitle': appLocalizations.offerFreeDeliverySubtitle,
          'color': const Color(0xFFFF6B35),
          'icon': '🚚',
          'image': 'assets/offer_delivery.png',
          'discount': appLocalizations.offerFreeDiscount,
        },
        {
          'title': appLocalizations.offerPizzaTitle,
          'subtitle': appLocalizations.offerPizzaSubtitle,
          'color': const Color(0xFFFF6B35),
          'icon': '🍕',
          'image': 'assets/offer_pizza.png',
          'discount': '50',
        },
      ]);

      _categories.addAll([
        {
          'name': appLocalizations.categoryFood,
          'image': "assets/images/food.png",
        },
        {
          'name': appLocalizations.categoryGrocery,
          'image': "assets/images/groceries.png",
        },
        {
          'name': appLocalizations.categoryMarkets,
          'image': "assets/images/markets.png",
        },
        {
          'name': appLocalizations.categoryPharmacies,
          'image': "assets/images/pharma2.png",
        },
        {
          'name': appLocalizations.categoryGifts,
          'image': "assets/images/gifts.png",
        },
        {
          'name': appLocalizations.categoryStores,
          'image': "assets/images/markets.png",
        },
      ]);
    });
  }

  void _startAutoSlide() {
    _offersTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (pageController.hasClients) {
        if (_currentSlide < _offers.length - 1) {
          _currentSlide++;
        } else {
          _currentSlide = 0;
        }
        pageController.animateToPage(
          _currentSlide,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _startCategoriesAutoSlide() {
    _categoriesTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_categoriesPageController.hasClients) {
        _currentCategoryPage++;
        if (_currentCategoryPage >= _categories.length - 2) {
          _currentCategoryPage = 0;
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final colors = context.colors;

    // ✅ تهيئة ScreenUtil هنا لو لسه مش مهيأ في الـ main
    return ScreenUtilInit(
      designSize: const Size(390, 844), // مقاس التصميم الأساسي (مثال iPhone 12)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: colors.background,
          body: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                current is HomeInitial ||
                current is HomeLoading ||
                current is HomeSuccess ||
                current is HomeError,
            builder: (context, state) {
              if (state is HomeInitial || state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                final isArabic =
                    Localizations.localeOf(context).languageCode == 'ar';
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w), // ✅ استخدمت .w
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off, size: 48.sp, color: colors.primary),
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

              final isArabic =
                  Localizations.localeOf(context).languageCode == 'ar';
              // Always use the fixed six categories on Home and ignore API categories
              final categories = _categories;

              final offers = state is HomeSuccess
                  ? state.offers
                      .map(
                        (offer) => {
                          'title': isArabic ? offer.titleAr : offer.title,
                          'subtitle':
                              isArabic ? offer.subtitleAr : offer.subtitle,
                          'color': _parseHexColor(offer.color) ??
                              const Color(0xFFFF6B35),
                          'icon': offer.icon.isNotEmpty ? offer.icon : '🍔',
                          'image': offer.image,
                          'discount': offer.discount,
                        },
                      )
                      .toList()
                  : _offers;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      onNotificationTap: _showNotificationsBottomSheet,
                      onSeeAllTap: _handleSeeAll,
                      categories: categories,
                      categoriesPageController: _categoriesPageController,
                      onCategoryTap: _handleCategoryTap,
                      offers: offers,
                      offersPageController: pageController,
                      currentOfferSlide: _currentSlide,
                      onOfferPageChanged: (index) {
                        setState(() {
                          _currentSlide = index;
                        });
                        HapticFeedback.lightImpact();
                      },
                      onOfferTap: _handleOfferTap,
                    ),
                    Transform.translate(
                      offset: Offset(0, -30.h), // ✅ Responsive translate
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
                            SizedBox(height: screenHeight * 0.01),
                            SectionHeader(
                              title: appLocalizations.favorites,
                              icon: Icons.favorite,
                              iconColor: const Color(0xFFFFD93D),
                              onSeeAllTap: _handleSeeAll,
                            ),
                            FavoriteRestaurantsList(
                              restaurants: state is HomeSuccess
                                  ? state.favoriteRestaurants
                                  : const [],
                              onRestaurantTap: _handleRestaurantTap,
                            ),
                            SizedBox(height: 8.h),
                            SectionHeader(
                              title: appLocalizations.topRatedRestaurants,
                              onSeeAllTap: _handleSeeAll,
                            ),
                            TopRatedRestaurantsList(
                              restaurants: state is HomeSuccess
                                  ? state.topRatedRestaurants
                                  : const [],
                              onRestaurantDetailTap: _handleRestaurantDetailTap,
                              onViewMenuTap: _handleViewMenu,
                            ),
                            SizedBox(height: 8.h),
                            SectionHeader(
                              title: appLocalizations.bestSelling,
                              onSeeAllTap: _handleSeeAll,
                            ),
                            FoodCardList(
                              foods: state is HomeSuccess
                                  ? state.bestSellingFoods
                                  : const [],
                              onFoodCardTap: _handleFoodCardTap,
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: _selectedNavIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedNavIndex = index;
              });
              HapticFeedback.lightImpact();
              _handleNavigation(index);
            },
          ),
        );
      },
    );
  }

  void _handleOfferTap(Map<String, dynamic> offer) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appLocalizations.offerTappedSnackbar(offer['title'])),
        backgroundColor: offer['color'],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleCategoryTap(Map<String, dynamic> category) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    HapticFeedback.lightImpact();

    final String tappedName = (category['name'] ?? '').toString();
    final String foodName = appLocalizations.categoryFood;

    if (tappedName == foodName) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const CategoriesPage(),
        ),
      );
      return;
    }
    // Other categories: do nothing for now
  }

  void _handleRestaurantTap(String name, int index) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اختيار مطعم: $name'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleRestaurantDetailTap(Map<String, dynamic> restaurant, int index) {
    HapticFeedback.lightImpact();
    _openRestaurantMenu(restaurant);
  }

  void _handleViewMenu(Map<String, dynamic> restaurant) {
    HapticFeedback.lightImpact();
    _openRestaurantMenu(restaurant);
  }

  void _handleSeeAll(String section) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض المزيد من: $section'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleNavigation(int index) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final pages = [
      appLocalizations.homePageTitle,
      appLocalizations.ordersTitle,
      appLocalizations.offersTitle,
      appLocalizations.accountTitle,
    ];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('انتقال إلى: ${pages[index]}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
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

extension _HomePageHelpers on FoodDeliveryHomePageState {
  void _openRestaurantMenu(Map<String, dynamic> restaurant) {
    final id = (restaurant['id'] ?? restaurant['_id'])?.toString() ?? '';
    final name = (restaurant['name'] ?? '')?.toString() ?? '';
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('معرف المطعم غير متوفر'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RestaurantMenuPage(
          restaurantId: id,
          restaurantName: name.isEmpty ? 'القائمة' : name,
        ),
      ),
    );
  }
  Color? _parseHexColor(String hex) {
    try {
      String value = hex.trim();
      if (value.startsWith('#')) value = value.substring(1);
      if (value.length == 6) value = 'FF$value';
      final intColor = int.parse(value, radix: 16);
      return Color(intColor);
    } catch (_) {
      return null;
    }
  }

  IconData _mapCategoryIcon(String name) {
    switch (name) {
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'local_grocery_store':
        return Icons.local_grocery_store;
      case 'store':
        return Icons.store;
      case 'medical_services':
        return Icons.medical_services;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'shopping_bag':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }
}
