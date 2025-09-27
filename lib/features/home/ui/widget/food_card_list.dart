import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodCardList extends StatelessWidget {
  final List<FoodModel> foods;
  final Function(String, int) onFoodCardTap;

  const FoodCardList({
    super.key,
    required this.foods,
    required this.onFoodCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (foods.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 0.30.sh, // 30% من ارتفاع الشاشة
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final FoodModel f = foods[index];
          final name = isArabic ? f.nameAr : f.name;
          final imageUrl = f.image;
          final rating = f.rating ?? 0;
          final priceStr = f.price!.toStringAsFixed(0);
          final emoji = '🍽️';

          return _buildFoodCard(
            context,
            name,
            imageUrl,
            rating,
            priceStr,
            emoji,
            index,
          );
        },
      ),
    );
  }

  Widget _buildFoodCard(
    BuildContext context,
    String name,
    String imageUrl,
    double rating,
    String price,
    String emojiFallback,
    int index,
  ) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: () => onFoodCardTap(name, index),
      child: Hero(
        tag: 'food_$index',
        child: Container(
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
                      Image.network(
                        imageUrl,
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
                              style: TextStyle(fontSize: 40.sp),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
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
                              Text(
                                rating.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
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
                            Text(
                              name,
                              style: textStyles.titleSmall?.copyWith(
                                fontSize: 16.sp,
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              appLocalizations.availableForDelivery,
                              style: textStyles.bodySmall?.copyWith(
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? '$price ريال' : '$price SAR',
                              style: textStyles.titleMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
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
        ),
      ),
    );
  }
}
