import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/ui/widget/SectionHeader.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final appLocalizations = AppLocalizations.of(context)!;

    return Shimmer(
      color: Colors.grey[300]!,
      colorOpacity: 0.3,
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HomeHeader Skeleton
          Container(
            height: 0.53.sh,
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
                        child: Icon(Icons.location_on, color: Colors.white, size: 24.sp),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80.w,
                              height: 12.h,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              width: 120.w,
                              height: 14.h,
                              color: Colors.white,
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
                          icon: Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24.sp),
                          onPressed: null,
                        ),
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
                      Container(
                        width: 100.w,
                        height: 20.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                // Categories Bar Skeleton
                SizedBox(
                  height: 120.h, // 70.h image + 20.h text + 4.h spacing + padding
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 6,
                    separatorBuilder: (_, __) => SizedBox(width: 0.w),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 110.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              elevation: 4,
                              shadowColor: colors.shadow.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                width: double.infinity,
                                height: 70.h,
                                child: Container(
                                  color: colors.surface,
                                  padding: EdgeInsets.all(6.0.w),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            SizedBox(
                              height: 20.h,
                              child: Center(
                                child: Container(
                                  width: 80.w,
                                  height: 12.h,
                                  color: colors.background,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                // Offers Slider Skeleton
                Container(
                  height: 0.18.sh,
                  width: 1.sw,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.3),
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
                            Container(
                              width: 200.w,
                              height: 20.h,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: 150.w,
                              height: 14.h,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10.h,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) => Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: index == 0 ? Colors.white : Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          // Body Skeleton
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
                  // Section Header Skeleton
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(width: 120.w, height: 20.h, color: colors.primary.withOpacity(0.3)),
                        const Spacer(),
                        Container(
                          width: 24.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Favorite Restaurants List Skeleton
                  SizedBox(
                    height: 170.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150.w,
                          margin: EdgeInsets.only(right: 12.w),
                          child: Card(
                            elevation: 6,
                            shadowColor: colors.shadow.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colors.primary.withOpacity(0.3),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.r),
                                            topRight: Radius.circular(16.r),
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
                                        top: 8.h,
                                        right: 8.w,
                                        child: Container(
                                          padding: EdgeInsets.all(4.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                blurRadius: 4.r,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.favorite_border,
                                            size: 14.sp,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100.w,
                                          height: 12.h,
                                          color: colors.primary.withOpacity(0.3),
                                        ),
                                        SizedBox(height: 4.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 12.sp,
                                              ),
                                              SizedBox(width: 2.w),
                                              Container(
                                                width: 20.w,
                                                height: 10.h,
                                                color: colors.onSurface.withOpacity(0.6),
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
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Favorite Foods List Skeleton
                  SizedBox(
                    height: 0.30.sh, // 30% من ارتفاع الشاشة
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 0.48.sw, // 48% من عرض الشاشة
                          margin: EdgeInsets.only(right: 16.w),
                          child: Card(
                            elevation: 8,
                            shadowColor: colors.shadow.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colors.primary.withOpacity(0.3),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.r),
                                            topRight: Radius.circular(20.r),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8.h,
                                        right: 8.w,
                                        child: InkWell(
                                          onTap: null,
                                          child: Container(
                                            padding: EdgeInsets.all(6.r),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.9),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4.r,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.favorite_border,
                                              size: 18.sp,
                                              color: colors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8.h,
                                        right: 8.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 2.w),
                                              Container(
                                                width: 20.w,
                                                height: 12.h,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.r),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 16.h,
                                              color: colors.primary.withOpacity(0.3),
                                            ),
                                            SizedBox(height: 4.h),
                                            Container(
                                              width: 120.w,
                                              height: 12.h,
                                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 60.w,
                                              height: 16.h,
                                              color: colors.primary.withOpacity(0.3),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(6.r),
                                              decoration: BoxDecoration(
                                                color: colors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: colors.onPrimary,
                                                size: 16.sp,
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
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Section Header Skeleton
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(width: 120.w, height: 20.h, color: colors.primary.withOpacity(0.3)),
                        const Spacer(),
                        Container(
                          width: 24.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Top Rated Restaurants List Skeleton
                  SizedBox(
                    height: 0.35.sh,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 0.55.sw,
                          margin: EdgeInsets.only(right: 16.w),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colors.primary.withOpacity(0.3),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.r),
                                            topRight: Radius.circular(20.r),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12.h,
                                        right: 12.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 2.w),
                                              Container(
                                                width: 20.w,
                                                height: 12.h,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150.w,
                                              height: 14.h,
                                              color: colors.primary.withOpacity(0.3),
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 14.sp,
                                                  color: colors.onSurface.withOpacity(0.6),
                                                ),
                                                SizedBox(width: 4.w),
                                                Container(
                                                  width: 60.w,
                                                  height: 12.h,
                                                  color: colors.primary.withOpacity(0.3),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                            Container(
                                              width: 80.w,
                                              height: 12.h,
                                              color: colors.primary.withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Container(
                                            height: 32.h,
                                            decoration: BoxDecoration(
                                              color: colors.primary,
                                              borderRadius: BorderRadius.circular(12.r),
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
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 0.h),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
