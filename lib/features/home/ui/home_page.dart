import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/ui/widget/SectionHeader.dart';
import 'package:deliva_eat/features/home/ui/widget/categories_bar.dart';
import 'package:deliva_eat/features/home/ui/widget/custom_botton_navigation_bar.dart';
import 'package:deliva_eat/features/home/ui/widget/favorite_restaurant_list.dart';
import 'package:deliva_eat/features/home/ui/widget/food_card_list.dart';
import 'package:deliva_eat/features/home/ui/widget/home_header.dart';
import 'package:deliva_eat/features/home/ui/widget/offer_slider.dart';
import 'package:deliva_eat/features/home/ui/widget/page_indecator.dart';
import 'package:deliva_eat/features/home/ui/widget/show_notifications_bottom_sheet.dart';
import 'package:deliva_eat/features/home/ui/widget/tages_offer_section.dart';
import 'package:deliva_eat/features/home/ui/widget/top_rated_resturant_list.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/features/home/cubit/home_cubit.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';
import 'package:deliva_eat/features/home/data/models/category_model.dart';
import 'package:deliva_eat/features/home/data/models/offer_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class FoodDeliveryHomePage extends StatefulWidget {
  const FoodDeliveryHomePage({super.key});

  @override
  FoodDeliveryHomePageState createState() => FoodDeliveryHomePageState();
}

class FoodDeliveryHomePageState extends State<FoodDeliveryHomePage>
    with TickerProviderStateMixin {
  // Page controller for offers slider
  final PageController pageController = PageController(viewportFraction: 0.9);
  Timer? _offersTimer;
  int _currentSlide = 0;

  // Page controller and timer for categories
  late final PageController _categoriesPageController;
  Timer? _categoriesTimer;
  int _currentCategoryPage = 0;

  int _selectedNavIndex = 0;

  final List<Map<String, dynamic>> _offers = []; // Initialized in initState using localizations

  final List<Map<String, dynamic>> _categories = []; // Initialized in initState using localizations

  @override
  void initState() {
    super.initState();

    // Initialize _categories and _offers after context is available for localizations
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
          'icon': Icons.restaurant_menu,
          'color': const Color(0xFFFF9800),
          'gradient': [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
        },
        {
          'name': appLocalizations.categoryGrocery,
          'icon': Icons.local_grocery_store,
          'color': const Color(0xFFFF9800),
          'gradient': [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
        },
        {
          'name': appLocalizations.categoryMarkets,
          'icon': Icons.store,
          'color': const Color(0xFFFF9800),
          'gradient': [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
        },
        {
          'name': appLocalizations.categoryPharmacies,
          'icon': Icons.medical_services,
          'color': const Color(0xFFFF9800),
          'gradient': [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
        },
        {
          'name': appLocalizations.categoryGifts,
          'icon': Icons.card_giftcard,
          'color': const Color(0xFFFF9800),
          'gradient': [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
        },
        {
          'name': appLocalizations.categoryStores,
          'icon': Icons.shopping_bag,
          'color': const Color(0xFFFF9800),
          'gradient': [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
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

  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            current is HomeInitial || current is HomeLoading || current is HomeSuccess || current is HomeError,
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            final isArabic = Localizations.localeOf(context).languageCode == 'ar';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, size: 48, color: colors.primary),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: context.textStyles.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => context.read<HomeCubit>().getHomeData(lang: isArabic ? 'ar' : 'en'),
                      icon: const Icon(Icons.refresh),
                      label: Text(AppLocalizations.of(context)!.resend),
                    ),
                  ],
                ),
              ),
            );
          }

          // Map backend data to UI maps expected by widgets; fallback to local data
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final categories = state is HomeSuccess
              ? state.categories
                  .map((cat) => {
                        'name': isArabic ? cat.nameAr : cat.name,
                        'icon': _mapCategoryIcon(cat.icon),
                        'color': _parseHexColor(cat.color) ?? const Color(0xFFFF9800),
                        'gradient': [
                          _parseHexColor(cat.gradient.isNotEmpty ? cat.gradient.first : cat.color) ?? const Color(0xFFFF9800),
                          _parseHexColor(cat.gradient.length > 1 ? cat.gradient[1] : cat.color) ?? const Color(0xFFFFCC02),
                        ],
                      })
                  .toList()
              : _categories;

          final offers = state is HomeSuccess
              ? state.offers
                  .map((offer) => {
                        'title': isArabic ? offer.titleAr : offer.title,
                        'subtitle': isArabic ? offer.subtitleAr : offer.subtitle,
                        'color': _parseHexColor(offer.color) ?? const Color(0xFFFF6B35),
                        'icon': offer.icon.isNotEmpty ? offer.icon : '🍔',
                        'image': offer.image,
                        'discount': offer.discount,
                      })
                  .toList()
              : _offers;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(onNotificationTap: _showNotificationsBottomSheet),
                // SizedBox(height: screenHeight * 0.01),
                SectionHeader(
                  title: appLocalizations.categories,
                  showSeeAll: false,
                  onSeeAllTap: _handleSeeAll,
                ),
                CategoriesBar(
                  categories: categories,
                  pageController: _categoriesPageController,
                  onCategoryTap: _handleCategoryTap,
                ),
                SizedBox(height: screenHeight * 0.01),
                OffersSlider(
                  offers: offers,
                  pageController: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentSlide = index;
                    });
                    HapticFeedback.lightImpact();
                  },
                  onOfferTap: _handleOfferTap,
                ),
                PageIndicator(
                  itemCount: offers.length,
                  currentIndex: _currentSlide,
                ),

                SizedBox(height: screenHeight * 0.01),
                SectionHeader(
                  title: appLocalizations.favorites,
                  icon: Icons.favorite,
                  iconColor: const Color(0xFFFFD93D),
                  onSeeAllTap: _handleSeeAll,
                ),
                FavoriteRestaurantsList(
                  restaurants: state is HomeSuccess ? state.favoriteRestaurants : const [],
                  onRestaurantTap: _handleRestaurantTap,
                ),
                SizedBox(height: screenHeight * 0.01),
                SectionHeader(
                  title: appLocalizations.topRatedRestaurants,
                  onSeeAllTap: _handleSeeAll,
                ),
                TopRatedRestaurantsList(
                  restaurants: state is HomeSuccess ? state.topRatedRestaurants : const [],
                  onRestaurantDetailTap: _handleRestaurantDetailTap,
                  onViewMenuTap: _handleViewMenu,
                ),
                SizedBox(height: screenHeight * 0.01),
                SectionHeader(
                  title: appLocalizations.bestSelling,
                  onSeeAllTap: _handleSeeAll,
                ),
                FoodCardList(
                  foods: state is HomeSuccess ? state.bestSellingFoods : const [],
                  onFoodCardTap: _handleFoodCardTap,
                ),
                SizedBox(height: screenHeight * 0.01),
              ],
            ),
          );
        },
      ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appLocalizations.categoryTappedSnackbar(category['name'])),
        backgroundColor: category['color'],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleFoodCardTap(String name, int index) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اختيار: $name'), // Consider adding a localization key for this
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleRestaurantTap(String name, int index) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اختيار مطعم: $name'), // Consider adding a localization key for this
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleRestaurantDetailTap(Map<String, dynamic> restaurant, int index) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض تفاصيل: ${restaurant['name']}'), // Consider adding a localization key for this
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleViewMenu(Map<String, dynamic> restaurant) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض قائمة: ${restaurant['name']}'), // Consider adding a localization key for this
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleTagTap(String tag) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تصفية حسب: $tag'), // Consider adding a localization key for this
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleSeeAll(String section) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض المزيد من: $section'), // Consider adding a localization key for this
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleNavigation(int index) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final pages = [appLocalizations.homePageTitle, appLocalizations.ordersTitle, appLocalizations.offersTitle, appLocalizations.accountTitle];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('انتقال إلى: ${pages[index]}'), // Consider adding a localization key for this
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

// Helper methods within the State class scope
extension _HomePageHelpers on FoodDeliveryHomePageState {
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