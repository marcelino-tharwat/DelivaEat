import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/ui/widget/page_indecator.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OffersSlider extends StatelessWidget {
  final List<Map<String, dynamic>> offers;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final Function(Map<String, dynamic>) onOfferTap;
  final int currentPageIndex;

  const OffersSlider({
    super.key,
    required this.offers,
    required this.pageController,
    required this.onPageChanged,
    required this.onOfferTap,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Container(
      height: 0.18.sh, // 50% من ارتفاع الشاشة
      width: 1.sw, // عرض الشاشة بالكامل
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: PageController(
              viewportFraction: 1,
            ), // ✅ كده ياخد الشاشة كلها
            // controller: pageController(viewportFraction: 1),
            onPageChanged: onPageChanged,
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Hero(
                tag: 'offer-${offer['title']}', // أو offer['id'] لو موجود
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(12.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          offer['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color:
                                    offer['color']?.withOpacity(0.5) ??
                                    Colors.grey,
                              ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                offer['title'],
                                style: context.textStyles.headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.7),
                                          offset: Offset(0, 2.h),
                                          blurRadius: 4.r,
                                        ),
                                      ],
                                    ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                offer['subtitle'],
                                style: context.textStyles.titleMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14.sp,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.7),
                                      offset: Offset(0, 1.h),
                                      blurRadius: 2.r,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10.h,
            child: PageIndicator(
              itemCount: offers.length,
              currentIndex: currentPageIndex,
            ),
          ),
        ],
      ),
    );
  }
}
