import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteMixedList extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final List<FoodModel> foods;
  final Function(String, int) onRestaurantTap;
  final Function(String, int) onFoodTap;
  final void Function(String restaurantId)? onToggleRestaurantFavorite;
  final void Function(String foodId)? onToggleFoodFavorite;

  const FavoriteMixedList({
    super.key,
    required this.restaurants,
    required this.foods,
    required this.onRestaurantTap,
    required this.onFoodTap,
    this.onToggleRestaurantFavorite,
    this.onToggleFoodFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (restaurants.isEmpty && foods.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = restaurants.length + foods.length;

    return SizedBox(
      height: 180.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: total,
        itemBuilder: (context, index) {
          if (index < restaurants.length) {
            final r = restaurants[index];
            final isArabic = Localizations.localeOf(context).languageCode == 'ar';
            final displayName = (isArabic ? r.nameAr : r.name) ?? '';
            final ratingStr = (r.rating ?? 0).toStringAsFixed(1);
            return _RestaurantCard(
              id: r.id ?? '',
              name: displayName,
              imageUrl: r.image,
              ratingStr: ratingStr,
              isFavorite: r.isFavorite ?? false,
              onTap: () => onRestaurantTap(displayName, index),
              onToggleFavorite: onToggleRestaurantFavorite == null
                  ? null
                  : () => onToggleRestaurantFavorite!(r.id ?? ''),
            );
          } else {
            final foodIndex = index - restaurants.length;
            final f = foods[foodIndex];
            final isArabic = Localizations.localeOf(context).languageCode == 'ar';
            final displayName = (isArabic ? f.nameAr : f.name) ?? '';
            final ratingStr = (f.rating ?? 0).toStringAsFixed(1);
            return _FoodCard(
              id: f.id ?? '',
              name: displayName,
              imageUrl: f.image,
              ratingStr: ratingStr,
              isFavorite: f.isFavorite ?? false,
              priceLabel: isArabic
                  ? '${(f.price ?? 0).toStringAsFixed(0)} ريال'
                  : '${(f.price ?? 0).toStringAsFixed(0)} SAR',
              onTap: () => onFoodTap(displayName, foodIndex),
              onToggleFavorite:
                  onToggleFoodFavorite == null ? null : () => onToggleFoodFavorite!(f.id ?? ''),
            );
          }
        },
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final String heroTag;
  final String name;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback onTap;
  final Widget bottomChip; // e.g. rating or price

  const _BaseCard({
    required this.heroTag,
    required this.name,
    required this.imageUrl,
    required this.isFavorite,
    required this.onTap,
    required this.bottomChip,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: Container(
          width: 150.w,
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
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colors.primary.withOpacity(0.08),
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
                            onTap: onToggleFavorite,
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 14.sp,
                              color: isFavorite ? Colors.white : colors.primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8.h,
                        right: 8.w,
                        child: bottomChip,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
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

class _RestaurantCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String ratingStr;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback onTap;

  const _RestaurantCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ratingStr,
    required this.isFavorite,
    required this.onTap,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _BaseCard(
      heroTag: 'favorite_restaurant_$id',
      name: name,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
      onTap: onTap,
      onToggleFavorite: onToggleFavorite,
      bottomChip: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 14),
            SizedBox(width: 2.w),
            Text(
              ratingStr,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String ratingStr;
  final String priceLabel;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback onTap;

  const _FoodCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ratingStr,
    required this.priceLabel,
    required this.isFavorite,
    required this.onTap,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _BaseCard(
      heroTag: 'favorite_food_$id',
      name: name,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
      onTap: onTap,
      onToggleFavorite: onToggleFavorite,
      bottomChip: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 14),
            SizedBox(width: 2.w),
            Text(
              ratingStr,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 6.w),
            Container(width: 1, height: 12.h, color: Colors.white.withOpacity(0.5)),
            SizedBox(width: 6.w),
            Text(
              priceLabel,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
