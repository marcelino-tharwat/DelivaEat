import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:deliva_eat/l10n/app_localizations.dart'; // Import the generated localizations

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

        // إذا وصل العداد إلى نهاية القائمة، أعده إلى الصفر
        if (_currentCategoryPage >= _categories.length - 2) {
          _currentCategoryPage = 0;
        }

        // قم بالتحريك الانسيابي إلى الصفحة المستهدفة (التالية أو الأولى)
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
            // 1. Header is now the first item in the scrollable column
            _buildHeader(),

            // 2. The rest of the page content follows
            SizedBox(height: screenHeight * 0.01),
            _buildSectionHeader(appLocalizations.categories, showSeeAll: false),
            _buildEnhancedCategoriesBar(),
            SizedBox(height: screenHeight * 0.01),

            _buildEnhancedOffersSlider(),
            _buildOffersPageIndicator(),
            SizedBox(height: screenHeight * 0.001),
            _buildSectionHeader(appLocalizations.offersAndBrands, showSeeAll: false),
            _buildEnhancedTagsOffersSection(),
            SizedBox(height: screenHeight * 0.01),

            _buildSectionHeader(
              appLocalizations.favorites,
              icon: Icons.favorite,
              iconColor: const Color(0xFFFFD93D),
            ),
            _buildEnhancedFavoritesSection(),
            SizedBox(height: screenHeight * 0.01),

            _buildSectionHeader(appLocalizations.topRatedRestaurants),
            _buildEnhancedTopRatedSection(),
            SizedBox(height: screenHeight * 0.01),
            _buildSectionHeader(appLocalizations.bestSelling),
            _buildEnhancedTrendingSection(),
            // SizedBox(height: screenHeight * 0.025),
          ],
        ),
      ),
      bottomNavigationBar: _buildEnhancedBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: colors.surface),
      // SafeArea is important here to avoid content overlapping with status bar
      child: SafeArea(
        bottom: false, // We only need padding at the top
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.location_on, color: colors.primary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'التوصيل إلى', // Hardcoded location, consider making this dynamic if needed
                    style: textStyles.bodySmall?.copyWith(
                      color: colors.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'الرياض, شارع الملك فهد', // Hardcoded location
                          style: textStyles.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: colors.onSurface,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: colors.onSurface,
                      size: 24,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B6B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => _showNotificationsBottomSheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedCategoriesBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      height: screenWidth * 0.27,
      child: PageView.builder(
        controller: _categoriesPageController,
        padEnds: false,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  shadowColor: colors.shadow.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: double.infinity,
                    height: screenWidth * 0.15,
                    color: colors.surface,
                    child: Icon(
                      category['icon'],
                      size: screenWidth * 0.08,
                      color: category['color'],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  textAlign: TextAlign.center,
                  style: textStyles.bodySmall?.copyWith(
                    color: colors.onBackground,
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.03,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedOffersSlider() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * 0.5,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentSlide = index;
          });
          HapticFeedback.lightImpact();
        },
        itemCount: _offers.length,
        itemBuilder: (context, index) {
          final offer = _offers[index];
          return Container(
            // margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Hero(
              tag: 'offer_$index',
              child: Card(
                elevation: 8,
                shadowColor: offer['color'].withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [offer['color'], offer['color'].withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: PatternPainter(offer['color']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        offer['title'],
                                        style: context.textStyles.headlineSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.055,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black
                                                  .withOpacity(0.3),
                                              offset: const Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        offer['subtitle'],
                                        style: context.textStyles.titleMedium
                                            ?.copyWith(
                                          color:
                                              Colors.white.withOpacity(0.9),
                                          fontSize: screenWidth * 0.04,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black
                                                  .withOpacity(0.3),
                                              offset: const Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '${offer['discount']}${offer['discount'] != appLocalizations.offerFreeDiscount ? '%' : ''}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _handleOfferTap(offer),
                                  icon: const Icon(Icons.shopping_cart,
                                      size: 18),
                                  label: Text(appLocalizations.orderNow),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: offer['color'],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                                Text(
                                  offer['icon'],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.12,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildOffersPageIndicator() {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_offers.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentSlide == index ? 24.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentSlide == index
                  ? colors.primary
                  : colors.outline.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    bool showSeeAll = true,
    IconData? icon,
    Color? iconColor,
  }) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? colors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? colors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: textStyles.titleLarge?.copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05, // Responsive font size
                ),
              ),
            ],
          ),
          if (showSeeAll)
            TextButton.icon(
              onPressed: () => _handleSeeAll(title),
              icon: const Icon(Icons.arrow_forward_ios, size: 14),
              label: Text(appLocalizations.seeAll),
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTagsOffersSection() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final tags = [
      {
        'name': appLocalizations.tagDiscounts,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.local_offer,
      },
      {
        'name': appLocalizations.tagNew,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.fiber_new,
      },
      {
        'name': appLocalizations.tagFreeDelivery,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.delivery_dining,
      },
      {
        'name': appLocalizations.tagFast,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.flash_on,
      },
      {'name': appLocalizations.tagHealthy, 'color': const Color(0xFFFFD93D), 'icon': Icons.eco},
      {
        'name': appLocalizations.tagDrinks,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.local_drink,
      },
      {'name': appLocalizations.tagSweets, 'color': const Color(0xFFFFD93D), 'icon': Icons.cake},
    ];

    final textStyles = context.textStyles;

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return GestureDetector(
            onTap: () => _handleTagTap(tag['name'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: (tag['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (tag['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tag['icon'] as IconData,
                    size: 16,
                    color: tag['color'] as Color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tag['name'] as String,
                    style: textStyles.bodySmall?.copyWith(
                      color: tag['color'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedTrendingSection() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      // Responsive height
      height: screenHeight * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildEnhancedFoodCard(
            ['نودلز حار', 'تاكو اللحم', 'لفافة فلافل', 'بيتزا مارجريتا'][index],
            [
              'assets/noodles.jpg',
              'assets/tacos.jpg',
              'assets/falafel.jpg',
              'assets/pizza.jpg',
            ][index],
            [4.5, 4.7, 4.3, 4.6][index],
            ['25 ريال', '30 ريال', '20 ريال', '40 ريال'][index],
            ['🍜', '🌮', '🌯', '🍕'][index],
            index,
          );
        },
      ),
    );
  }

  Widget _buildEnhancedFoodCard(
    String name,
    String imagePath,
    double rating,
    String price,
    String emojiFallback,
    int index,
  ) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _handleFoodCardTap(name, index),
      child: Hero(
        tag: 'food_$index',
        child: Container(
          width: screenWidth * 0.48,
          margin: const EdgeInsets.only(right: 0),
          child: Card(
            elevation: 8,
            shadowColor: colors.shadow.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Top Image Section ---
                Expanded(
                  // التغيير الأول: تعديل نسبة الـ flex لتكون متساوية
                  flex: 2,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primary.withOpacity(0.3),
                                colors.primary.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              emojiFallback,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // --- Bottom Info Section ---
                Expanded(
                  // النسبة الآن متساوية مع الصورة
                  flex: 2,
                  child: Padding(
                    // التغيير الثاني: تقليل الـ Padding قليلًا
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: textStyles.titleSmall?.copyWith(
                                fontSize: screenWidth * 0.04,
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appLocalizations.availableForDelivery,
                              style: textStyles.bodySmall?.copyWith(
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              price,
                              style: textStyles.titleMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: colors.onPrimary,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedFavoritesSection() {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      // Responsive height
      height: screenHeight * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: 4,
        itemBuilder: (context, index) {
          final restaurants = [
            {
              'name': 'مطعم النور',
              'rating': '4.8',
              'image': 'assets/restaurant_1.jpg',
            },
            {
              'name': 'برجر ستيشن',
              'rating': '4.6',
              'image': 'assets/restaurant_2.jpg',
            },
            {
              'name': 'سوشي هاوس',
              'rating': '4.9',
              'image': 'assets/restaurant_3.jpg',
            },
            {
              'name': 'كافيه السعادة',
              'rating': '4.5',
              'image': 'assets/restaurant_4.jpg',
            },
          ];

          return _buildEnhancedFavoriteCard(
            restaurants[index]['name']!,
            restaurants[index]['rating']!,
            restaurants[index]['image']!,
            index,
          );
        },
      ),
    );
  }

  Widget _buildEnhancedFavoriteCard(
    String name,
    String rating,
    String imagePath,
    int index,
  ) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _handleRestaurantTap(name, index),
      child: Hero(
        tag: 'restaurant_$index',
        child: Container(
          width: screenWidth * 0.32,
          margin: const EdgeInsets.only(right: 0),
          child: Card(
            elevation: 6,
            shadowColor: colors.shadow.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Expanded(
                  // التغيير هنا: تعديل نسبة الـ flex
                  flex: 2,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primary.withOpacity(0.3),
                                colors.primary.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text('🏪', style: TextStyle(fontSize: 30)),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // النسبة الآن متساوية مع الصورة
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: textStyles.bodyMedium?.copyWith(                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.032,
                            color: colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating,
                                style: textStyles.bodySmall?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTopRatedSection() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      // Responsive height
      height: screenHeight * 0.35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: 3,
        itemBuilder: (context, index) {
          final restaurants = [
            {
              'name': 'قصر البيتزا',
              'rating': '4.5',
              'avgPrice': '15 ريال متوسط',
              'emoji': '🍕',
              'image': 'assets/pizza_place.png',
              'deliveryTime': '25-35 دقيقة',
              'specialty': 'إيطالي',
            },
            {
              'name': 'برجر بارن',
              'rating': '4.7',
              'avgPrice': '12 ريال متوسط',
              'emoji': '🍔',
              'image': 'assets/burger_place.png',
              'deliveryTime': '20-30 دقيقة',
              'specialty': 'أمريكي',
            },
            {
              'name': 'سوشي سبوت',
              'rating': '4.8',
              'avgPrice': '35 ريال متوسط',
              'emoji': '🍣',
              'image': 'assets/sushi_place.png',
              'deliveryTime': '30-45 دقيقة',
              'specialty': 'ياباني',
            },
          ];

          return _buildEnhancedRestaurantCard(restaurants[index], index);
        },
      ),
    );
  }

  Widget _buildEnhancedRestaurantCard(
    Map<String, dynamic> restaurant,
    int index,
  ) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _handleRestaurantDetailTap(restaurant, index),
      child: Hero(
        tag: 'top_restaurant_$index',
        child: Container(
          width: screenWidth * 0.55,
          margin: const EdgeInsets.only(right: 0),
          child: Card(
            elevation: 10,
            shadowColor: colors.shadow.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Top Image Section ---
                Expanded(
                  // التغيير الرئيسي هنا: تقليل مساحة الصورة
                  flex: 2,
                  child: Stack(
                    fit: StackFit.expand, // Make stack fill the expanded area
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          restaurant['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colors.primary.withOpacity(0.3),
                                      colors.primary.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    restaurant['emoji'],
                                    style: const TextStyle(fontSize: 50),
                                  ),
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            restaurant['specialty'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                restaurant['rating'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Bottom Info Section ---
                Expanded(
                  // النسبة متساوية الآن مع الصورة لضمان مساحة كافية
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // إعادة استخدام spaceBetween لدفع الزر إلى الأسفل
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Column for text content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'],
                              style: textStyles.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                                fontSize: screenWidth * 0.04,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: colors.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    restaurant['deliveryTime'],
                                    style: textStyles.bodySmall?.copyWith(
                                      color: colors.onSurface.withOpacity(0.6),
                                      fontSize: screenWidth * 0.03,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant['avgPrice'],
                              style: textStyles.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // Button at the bottom
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _handleViewMenu(restaurant),
                            icon: const Icon(Icons.restaurant_menu, size: 16),
                            label: Text(appLocalizations.viewMenu),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 0,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedBottomNavigation() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive height with min/max clamps to look good on all devices
    final navBarHeight = (screenHeight * 0.09).clamp(70.0, 90.0);

    return Container(
      height: navBarHeight,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEnhancedNavItem(appLocalizations.homePageTitle, Icons.home_rounded, 0),
            _buildEnhancedNavItem(appLocalizations.ordersTitle, Icons.receipt_long_rounded, 1),
            _buildEnhancedNavItem(appLocalizations.offersTitle, Icons.local_offer_rounded, 2),
            _buildEnhancedNavItem(appLocalizations.accountTitle, Icons.person_rounded, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedNavItem(String title, IconData icon, int index) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        HapticFeedback.lightImpact();
        _handleNavigation(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                Icon(
                  icon,
                  color: isSelected
                      ? colors.primary
                      : colors.onSurface.withOpacity(0.6),
                  size: isSelected ? 26 : 24,
                ),
              ],
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style:
                  textStyles.bodySmall?.copyWith(
                    color: isSelected
                        ? colors.primary
                        : colors.onSurface.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: isSelected ? 11 : 10,
                  ) ??
                  const TextStyle(),
              child: Text(title),
            ),
          ],
        ),
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appLocalizations.notifications,
                    style: context.textStyles.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text(appLocalizations.readAll)),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    Divider(color: context.colors.outline.withOpacity(0.3)),
                itemBuilder: (context, index) {
                  final notifications = [
                    {
                      'title': 'تم قبول طلبك', // Consider localization for notifications
                      'subtitle': 'طلبك من مطعم النور قيد التحضير',
                      'time': 'منذ 5 دقائق',
                      'icon': Icons.restaurant,
                      'color': const Color(0xFF4CAF50),
                    },
                    {
                      'title': 'عرض خاص لك!',
                      'subtitle': 'خصم 25% على طلبك القادم',
                      'time': 'منذ ساعة',
                      'icon': Icons.local_offer,
                      'color': const Color(0xFFFF9800),
                    },
                    {
                      'title': 'تم توصيل الطلب',
                      'subtitle': 'وصل طلبك بنجاح، نرجو التقييم',
                      'time': 'منذ ساعتين',
                      'icon': Icons.check_circle,
                      'color': const Color(0xFF2196F3),
                    },
                    {
                      'title': 'مطعم جديد!',
                      'subtitle': 'افتتح مطعم جديد في منطقتك',
                      'time': 'أمس',
                      'icon': Icons.store,
                      'color': const Color(0xFF9C27B0),
                    },
                    {
                      'title': 'تذكير',
                      'subtitle': 'لديك نقاط يمكن استبدالها',
                      'time': 'منذ يومين',
                      'icon': Icons.stars,
                      'color': const Color(0xFFFFD700),
                    },
                  ];

                  final notification = notifications[index];

                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (notification['color'] as Color).withOpacity(
                          0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        notification['icon'] as IconData,
                        color: notification['color'] as Color,
                      ),
                    ),
                    title: Text(
                      notification['title'] as String,
                      style: context.textStyles.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notification['subtitle'] as String,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: context.colors.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification['time'] as String,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index < 2
                            ? context.colors.primary
                            // ignore: use_full_hex_values_for_flutter_colors
                            : const Color(0x0000000),
                        shape: BoxShape.circle,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    onTap: () {
                      Navigator.pop(context);
                      HapticFeedback.lightImpact();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2;

    final path = Path();

    // Draw decorative circles
    for (int i = 0; i < 3; i++) {
      final radius = 20.0 + (i * 10);
      final center = Offset(
        size.width * 0.85 + (i * 15),
        size.height * 0.2 + (i * 20),
      );

      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, paint);
    }

    // Draw some diagonal lines
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < 5; i++) {
      final startX = size.width * 0.7;
      final startY = i * 25.0;
      final endX = size.width * 0.9;
      final endY = startY + 15;

      path.moveTo(startX, startY);
      path.lineTo(endX, endY);
    }

    canvas.drawPath(path, paint);

    // Add some dots pattern
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 3; j++) {
        final x = size.width * 0.75 + (i * 8);
        final y = size.height * 0.6 + (j * 8);
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}