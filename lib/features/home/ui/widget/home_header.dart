import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/core/theme/provider.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'categories_bar.dart';
import 'offer_slider.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final Function(String) onSeeAllTap;
  final List<Map<String, dynamic>> categories;
  final PageController categoriesPageController;
  final Function(Map<String, dynamic>) onCategoryTap;
  final List<Map<String, dynamic>> offers;
  final PageController offersPageController;
  final int currentOfferSlide;
  final ValueChanged<int> onOfferPageChanged;
  final Function(Map<String, dynamic>) onOfferTap;

  const HomeHeader({
    super.key,
    required this.onNotificationTap,
    required this.onSeeAllTap,
    required this.categories,
    required this.categoriesPageController,
    required this.onCategoryTap,
    required this.offers,
    required this.offersPageController,
    required this.currentOfferSlide,
    required this.onOfferPageChanged,
    required this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final appLocalizations = AppLocalizations.of(context)!;

    return Container(
      height: 0.53.sh, // 63% من ارتفاع الشاشة
      width: double.infinity,
      decoration: BoxDecoration(color: colors.primary),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 45.h,
              left: 20.w,
              right: 20.w,
              bottom: 0.h,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.deliveryTo,
                        style: textStyles.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        appLocalizations.selected_address,
                        style: textStyles.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        Positioned(
                          top: 2.h,
                          right: 2.w,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6B6B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: onNotificationTap,
                  ),
                ),
                SizedBox(width: 12.w),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: () {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.categories,
                  style: textStyles.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          CategoriesBar(
            categories: categories,
            pageController: categoriesPageController,
            onCategoryTap: onCategoryTap,
          ),
          SizedBox(height: 10.h),
          MediaQuery.removePadding(
            context: context,
            removeLeft: true,
            removeRight: true,
            removeTop: true,
            child: OffersSlider(
              currentPageIndex: currentOfferSlide,
              offers: offers,
              pageController: offersPageController,
              onPageChanged: onOfferPageChanged,
              onOfferTap: onOfferTap,
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
