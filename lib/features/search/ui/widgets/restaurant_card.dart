import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = isArabic ? restaurant.nameAr : restaurant.name;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Card(
        elevation: 6,
        shadowColor: colors.shadowColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Navigate to restaurant details
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Hero(
                  tag: 'restaurant-${restaurant.id}',
                  child: Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        restaurant.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primaryColor.withOpacity(0.3),
                                colors.primaryColor.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text('🏪', style: TextStyle(fontSize: 30)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: colors.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          if (restaurant.rating != null) ...[
                            Icon(Icons.star, color: Colors.amber, size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              restaurant.rating!.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                          ],
                          Icon(
                            Icons.access_time,
                            color: colors.hintColor,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              restaurant.deliveryTime ?? '',
                              style: TextStyle(
                                color: colors.hintColor,
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          restaurant.deliveryFee != null
                              ? "${l10n.deliveryFeeLabel}${restaurant.deliveryFee} ${l10n.riyal}"
                              : "${l10n.deliveryFeeLabel}${l10n.notSpecified}",
                          style: TextStyle(
                            color: colors.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: colors.hintColor,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
