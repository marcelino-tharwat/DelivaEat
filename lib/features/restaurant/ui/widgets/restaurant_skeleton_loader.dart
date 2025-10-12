import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantSkeletonLoader extends StatefulWidget {
  const RestaurantSkeletonLoader({super.key});

  @override
  State<RestaurantSkeletonLoader> createState() =>
      _RestaurantSkeletonLoaderState();
}

class _RestaurantSkeletonLoaderState extends State<RestaurantSkeletonLoader> {
  late List<bool> itemEnabled;

  @override
  void initState() {
    super.initState();
    itemEnabled = List.generate(5, (_) => true);
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) {
          setState(() {
            itemEnabled[i] = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          // الهيدر مع الصورة والأزرار
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // الصورة الخلفية
              Container(
                height: 280.h,
                width: double.infinity,
                color: colorScheme.primary.withOpacity(0.3),
              ),
              // زر الرجوع
              Positioned(
                top: 50.h,
                left: 16.w,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface.withOpacity(0.8),
                  ),
                ),
              ),
              // زر المفضلة
              Positioned(
                top: 50.h,
                right: 16.w,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              // اللوجو
              Positioned(
                top: 90.h,
                child: Container(
                  width: 130.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              // العروض
              Positioned(
                top: 230.h,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // الحاوية البيضاء السفلية
              Positioned(
                top: 260.h,
                left: 0,
                right: 0,
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // شريط التصنيفات
          Container(
            margin: EdgeInsets.only(top: 40.h),
            decoration: BoxDecoration(color: colorScheme.surface),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      color: colorScheme.primary.withOpacity(0.3),
                    ),
                    SizedBox(width: 10.w),
                    ...List.generate(
                      4,
                      (index) => Container(
                        width: 60.w,
                        height: 30.h,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          color: index == 0
                              ? colorScheme.primary.withOpacity(0.3)
                              : colorScheme.surface,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // عناصر الطعام
          Container(
            color: colorScheme.surface,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان القسم
                  Container(
                    width: 100.w,
                    height: 24.h,
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                  SizedBox(height: 16.h),
                  // بطاقات الطعام
                  ...List.generate(
                    5,
                    (index) => Skeletonizer(
                      enabled: itemEnabled[index],
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withOpacity(0.2),
                              blurRadius: 4.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              Container(
                                width: 110.w,
                                height: 110.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150.w,
                                      height: 20.h,
                                      color: colorScheme.primary.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      width: 200.w,
                                      height: 16.h,
                                      color: colorScheme.primary.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 60.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary
                                                .withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(
                                              6.r,
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
