import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopRatedRestaurantsList extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final Function(Map<String, dynamic>, int) onRestaurantDetailTap;
  final Function(Map<String, dynamic>) onViewMenuTap;
  final void Function(String restaurantId)? onToggleFavorite;

  const TopRatedRestaurantsList({
    super.key,
    required this.restaurants,
    required this.onRestaurantDetailTap,
    required this.onViewMenuTap,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 0.35.sh, // ارتفاع متجاوب
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final RestaurantModel r = restaurants[index];
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final Map<String, dynamic> item = {
            'id': r.id,
            'name': isArabic ? r.nameAr : r.name,
            'rating': r.rating!.toStringAsFixed(1),
            'avgPrice': '',
            'emoji': '🍽️',
            'image': r.image,
            'deliveryTime': r.deliveryTime,
            'specialty': '',
            'isFavorite': r.isFavorite ?? false,
          };
          return _buildRestaurantCard(context, item, index);
        },
      ),
    );
  }

  Widget _buildRestaurantCard(
    BuildContext context,
    Map<String, dynamic> restaurant,
    int index,
  ) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GestureDetector(
      onTap: () => onRestaurantDetailTap(restaurant, index),
      child: Hero(
        tag: 'top_restaurant_$index',
        child: Container(
          width: 0.55.sw, // عرض متجاوب
          margin: EdgeInsets.only(right: 16.w),
          child: Card(
            elevation: 10,
            shadowColor: colors.shadow.withOpacity(0.2),
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
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        child: Image.network(
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
                                    restaurant['emoji'] ?? '🍽️',
                                    style: TextStyle(fontSize: 50.sp),
                                  ),
                                ),
                              ),
                        ),
                      ),
                      restaurant['specialty'] == null ||
                              restaurant['specialty'] == ''
                          ? const SizedBox.shrink()
                          : Positioned(
                              top: 12.h,
                              right: 12.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  restaurant['specialty'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                              Text(
                                restaurant['rating'],
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
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: InkWell(
                          onTap: () => onToggleFavorite?.call((restaurant['id'] ?? '').toString()),
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
                              (restaurant['isFavorite'] == true)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18.sp,
                              color: (restaurant['isFavorite'] == true)
                                  ? Colors.red
                                  : colors.primary,
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
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'],
                              style: textStyles.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                                Expanded(
                                  child: Text(
                                    restaurant['deliveryTime'],
                                    style: textStyles.bodySmall?.copyWith(
                                      color: colors.onSurface.withOpacity(0.6),
                                      fontSize: 12.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              restaurant['avgPrice'],
                              style: textStyles.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => onViewMenuTap(restaurant),
                            icon: Icon(Icons.restaurant_menu, size: 16.sp),
                            label: Text(
                              appLocalizations.viewMenu,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 6.h),
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
}
