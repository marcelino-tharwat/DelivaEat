import 'dart:async';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/home/ui/widget/SectionHeader.dart';
import 'package:deliva_eat/features/home/ui/widget/custom_botton_navigation_bar.dart';
import 'package:deliva_eat/features/home/ui/widget/food_card_list.dart';
import 'package:deliva_eat/features/home/ui/widget/home_header.dart';
import 'package:deliva_eat/features/home/ui/widget/show_notifications_bottom_sheet.dart';
import 'package:deliva_eat/features/home/ui/widget/top_rated_resturant_list.dart';
import 'package:deliva_eat/features/home/ui/widget/favorite_restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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

  // سيتم ملء هذه القوائم من cubit والترجمات
  final List<Map<String, dynamic>> _staticCategories = [];

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

    final appLocalizations = AppLocalizations.of(context)!;
    setState(() {
      _staticCategories.addAll([
        {'id': 'food', 'name': appLocalizations.categoryFood, 'image': "assets/images/food.png"},
        {'id': 'grocery', 'name': appLocalizations.categoryGrocery, 'image': "assets/images/groceries.png"},
        {'id': 'markets', 'name': appLocalizations.categoryMarkets, 'image': "assets/images/markets.png"},
        {'id': 'pharmacies', 'name': appLocalizations.categoryPharmacies, 'image': "assets/images/pharma2.png"},
        {'id': 'gifts', 'name': appLocalizations.categoryGifts, 'image': "assets/images/gifts.png"},
        {'id': 'stores', 'name': appLocalizations.categoryStores, 'image': "assets/images/markets.png"},
      ]);
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
      if (_categoriesPageController.hasClients && _staticCategories.length > 3) {
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
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: colors.background,
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeInitial || state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return _buildErrorState(state, context);
              }

              if (state is HomeSuccess) {
                final isArabic = Localizations.localeOf(context).languageCode == 'ar';
                final offers = state.offers.map((offer) => {
                      'title': isArabic ? offer.titleAr : offer.title,
                      'subtitle': isArabic ? offer.subtitleAr : offer.subtitle,
                      'color': _parseHexColor(offer.color) ?? const Color(0xFFFF6B35),
                      'icon': offer.icon.isNotEmpty ? offer.icon : '🍔',
                      'image': offer.image,
                      'discount': offer.discount,
                    }).toList();

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
                        onOfferPageChanged: (index) => setState(() => _currentSlide = index),
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
                              FavoriteRestaurantsList(
                                restaurants: state.favoriteRestaurants,
                                onRestaurantTap: _handleRestaurantTap,
                              ),
                              SizedBox(height: 8.h),
                              SectionHeader(
                                title: AppLocalizations.of(context)!.topRatedRestaurants,
                                onSeeAllTap: _handleSeeAll,
                              ),
                              TopRatedRestaurantsList(
                                restaurants: state.topRatedRestaurants,
                                onRestaurantDetailTap: _handleRestaurantDetailTap,
                                onViewMenuTap: _handleViewMenu,
                              ),
                              SizedBox(height: 8.h),
                              SectionHeader(
                                title: AppLocalizations.of(context)!.bestSelling,
                                onSeeAllTap: _handleSeeAll,
                              ),
                              FoodCardList(
                                foods: state.bestSellingFoods,
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
              }
              return const SizedBox.shrink(); // حالة غير متوقعة
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
      },
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
            Text(state.message, textAlign: TextAlign.center, style: context.textStyles.titleMedium),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              onPressed: () => context.read<HomeCubit>().getHomeData(lang: isArabic ? 'ar' : 'en'),
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text(AppLocalizations.of(context)!.resend, style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }

  // --- Handlers ---
  
  void _handleFoodCardTap(String name, int index) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم اختيار: $name')));
  }

  void _handleOfferTap(Map<String, dynamic> offer) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.offerTappedSnackbar(offer['title']))),
    );
  }

  void _handleCategoryTap(Map<String, dynamic> category) {
    HapticFeedback.lightImpact();
    final String categoryId = (category['id'] ?? '').toString();

    switch (categoryId) {
      case 'food':
        context.push(AppRoutes.categoryPage);
        break;
      case 'grocery':
      case 'markets':
      case 'pharmacies':
      case 'gifts':
      case 'stores':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('قسم "${category['name']}" سيتم إضافته قريباً!')),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فئة غير معروفة')));
    }
  }
  
  void _handleRestaurantTap(String name, int index) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم اختيار مطعم: $name')));
  }

  void _handleRestaurantDetailTap(Map<String, dynamic> restaurant, int index) {
    _openRestaurantMenu(restaurant);
  }

  void _handleViewMenu(Map<String, dynamic> restaurant) {
    _openRestaurantMenu(restaurant);
  }

  void _handleSeeAll(String section) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('عرض المزيد من: $section')));
  }

  void _handleNavigation(int index) {
    // يمكنك هنا استخدام GoRouter للتنقل إذا كان لديك ShellRoute
    // مثال: context.go('/orders');
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final pages = [appLocalizations.homePageTitle, appLocalizations.ordersTitle, appLocalizations.offersTitle, appLocalizations.accountTitle];
    if (index != _selectedNavIndex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('انتقال إلى: ${pages[index]}')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('معرف المطعم غير متوفر')));
      return;
    }
    
    // استخدام GoRouter مع تمرير البارامترات
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