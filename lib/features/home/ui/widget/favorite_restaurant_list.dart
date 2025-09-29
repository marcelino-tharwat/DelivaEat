import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteRestaurantsList extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final Function(String, int) onRestaurantTap;
  final void Function(String restaurantId)? onToggleFavorite;

  const FavoriteRestaurantsList({
    super.key,
    required this.restaurants,
    required this.onRestaurantTap,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 150.h, // بدل MediaQuery بـ .h
      
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final RestaurantModel r = restaurants[index];
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final displayName = isArabic ? r.nameAr : r.name;
          final ratingStr = r.rating!.toStringAsFixed(1);
          final imageUrl = r.image;

          return _buildFavoriteCard(
            context,
            displayName,
            ratingStr,
            imageUrl,
            r.id,
            r.isFavorite ?? false,
            index,
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    String name,
    String ratingStr,
    String imageUrl,
    String restaurantId,
    bool isFavorite,
    int index,
  ) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GestureDetector(
      onTap: () => onRestaurantTap(name, index),
      child: Hero(
        tag: 'favorite_restaurant_$restaurantId',
        child: Container(
          width: 150.w,
          // margin: EdgeInsets.only(right: 16.w),
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
                          child: const Center(
                            child: Text('🏪', style: TextStyle(fontSize: 30)),
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
                            color: isFavorite ? const Color(0xFFFF6B6B) : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4.r,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () => onToggleFavorite?.call(restaurantId),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 14.sp,
                              color: isFavorite ? Colors.white : colors.primary,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: textStyles.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                              Text(
                                ratingStr,
                                style: textStyles.bodySmall?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
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
        ),
      ),
    );
  }
}
