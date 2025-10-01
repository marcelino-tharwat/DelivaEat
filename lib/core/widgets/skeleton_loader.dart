import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  Widget _buildSectionHeader(BuildContext context) {
    final colors = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: colors.primaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 12.w),
        Container(width: 120.w, height: 20.h, color: Colors.white),
        const Spacer(),
        Container(
          width: 24.w,
          height: 22.h,
          decoration: BoxDecoration(
            color: colors.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantCardSkeleton(BuildContext context) {
    final colors = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Card(
        elevation: 6,
        shadowColor: colors.shadowColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: colors.primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 20.h,
                      color: colors.primaryColor.withOpacity(0.3),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 16.h,
                          color: colors.primaryColor.withOpacity(0.3),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          width: 60.w,
                          height: 16.h,
                          color: colors.primaryColor.withOpacity(0.3),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 100.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: colors.primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 16.w,
                height: 16.h,
                color: colors.primaryColor.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCardSkeleton(BuildContext context) {
    final colors = Theme.of(context);
    return Container(
      width: 150.w,
      // height: 200.h,
      // margin: EdgeInsets.only(right: 12.w),
      child: Card(
        elevation: 6,
        shadowColor: colors.shadowColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 17.h,
                      color: colors.primaryColor.withOpacity(0.3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.w,
                              height: 16.h,
                              color: colors.primaryColor.withOpacity(0.3),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: 40.w,
                              height: 12.h,
                              color: colors.primaryColor.withOpacity(0.3),
                            ),
                          ],
                        ),
                        Container(
                          width: 40.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: colors.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10.r),
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
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: Colors.grey[300]!,
      colorOpacity: 0.3,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context),
              SizedBox(height: 16.h),
              ...List.generate(3, (_) => _buildRestaurantCardSkeleton(context)),
              SizedBox(height: 24.h),
              _buildSectionHeader(context),
              SizedBox(height: 16.h),
              SizedBox(
                height: 190.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildFoodCardSkeleton(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
