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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
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
              categories: _categories,
              pageController: _categoriesPageController,
              onCategoryTap: _handleCategoryTap,
            ),
            SizedBox(height: screenHeight * 0.01),
            OffersSlider(
              offers: _offers,
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
              itemCount: _offers.length,
              currentIndex: _currentSlide,
            ),
            SizedBox(height: screenHeight * 0.001),
            SectionHeader(
              title: appLocalizations.offersAndBrands,
              showSeeAll: false,
              onSeeAllTap: _handleSeeAll,
            ),
            TagsOffersSection(onTagTap: _handleTagTap),
            SizedBox(height: screenHeight * 0.01),
            SectionHeader(
              title: appLocalizations.favorites,
              icon: Icons.favorite,
              iconColor: const Color(0xFFFFD93D),
              onSeeAllTap: _handleSeeAll,
            ),
            FavoriteRestaurantsList(onRestaurantTap: _handleRestaurantTap),
            SizedBox(height: screenHeight * 0.01),
            SectionHeader(
              title: appLocalizations.topRatedRestaurants,
              onSeeAllTap: _handleSeeAll,
            ),
            TopRatedRestaurantsList(
              onRestaurantDetailTap: _handleRestaurantDetailTap,
              onViewMenuTap: _handleViewMenu,
            ),
            SizedBox(height: screenHeight * 0.01),
            SectionHeader(
              title: appLocalizations.bestSelling,
              onSeeAllTap: _handleSeeAll,
            ),
            FoodCardList(onFoodCardTap: _handleFoodCardTap),
          ],
        ),
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