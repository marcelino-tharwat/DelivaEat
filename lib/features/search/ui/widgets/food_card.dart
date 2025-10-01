import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;
  final int index;

  const FoodCard({
    super.key,
    required this.food,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = isArabic ? food.nameAr : food.name;
    final hasDiscount =
        food.originalPrice != null && food.price != null && food.originalPrice! > food.price!.toInt();

    return Container(
      width: 150.w,
      margin: EdgeInsets.only(left: 12.w),
      child: Card(
        elevation: 6,
        shadowColor: colors.shadowColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Navigate to food details
          },
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'food-item-${food.id}-$index',
                      child: Image.network(
                        food.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primaryColor.withOpacity(0.3),
                                colors.primaryColor.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text('🍕', style: TextStyle(fontSize: 30)),
                          ),
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
                    if (hasDiscount)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            l10n.discount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        displayName,
                        style: colors.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: colors.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.price != null ? "${food.price} ${l10n.riyal}" : l10n.notSpecified,
                                style: TextStyle(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              if (hasDiscount)
                                Text(
                                  "${food.originalPrice} ${l10n.riyal}",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: colors.hintColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                            ],
                          ),
                          if (food.rating != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryColor.withOpacity(0.1),
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
                                  Text(
                                    food.rating!.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: colors.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
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
    );
  }
}
