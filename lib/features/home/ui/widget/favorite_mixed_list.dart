import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// --- IMPROVEMENT 1: Create a unified model/interface ---
// This helps in creating a single list and simplifies the builder logic.
abstract class FavoriteItem {
  String get id;
  String get name;
  String get nameAr;
  String? get image;
  double get rating;
  bool get isFavorite;
}

// Make your models implement this interface
// Example: class RestaurantModel implements FavoriteItem { ... }
// Example: class FoodModel implements FavoriteItem { ... }

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
    // --- IMPROVEMENT 2: Combine lists for simpler logic ---
    final List<dynamic> combinedList = [...restaurants, ...foods];

    if (combinedList.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200.h, // Increased height slightly for better spacing
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // --- IMPROVEMENT 3: Add padding for better aesthetics ---
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: combinedList.length,
        itemBuilder: (context, index) {
          final item = combinedList[index];
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';

          if (item is RestaurantModel) {
            final displayName = (isArabic ? item.nameAr : item.name) ?? '';
            return _RestaurantCard(
              id: item.id ?? '',
              name: displayName,
              imageUrl: item.image ?? '',
              rating: item.rating ?? 0,
              isFavorite: item.isFavorite ?? false,
              onTap: () =>
                  onRestaurantTap(displayName, restaurants.indexOf(item)),
              onToggleFavorite: onToggleRestaurantFavorite == null
                  ? null
                  : () => onToggleRestaurantFavorite!(item.id ?? ''),
            );
          } else if (item is FoodModel) {
            final foodIndex = foods.indexOf(item);
            final displayName = (isArabic ? item.nameAr : item.name) ?? '';
            final priceLabel = isArabic
                ? '${(item.price ?? 0).toStringAsFixed(0)} ريال'
                : '${(item.price ?? 0).toStringAsFixed(0)} SAR';
            return _FoodCard(
              id: item.id ?? '',
              name: displayName,
              imageUrl: item.image ?? '',
              rating: item.rating ?? 0,
              priceLabel: priceLabel,
              isFavorite: item.isFavorite ?? false,
              onTap: () => onFoodTap(displayName, foodIndex),
              onToggleFavorite: onToggleFoodFavorite == null
                  ? null
                  : () => onToggleFoodFavorite!(item.id ?? ''),
            );
          }
          return const SizedBox.shrink();
        },
        // --- IMPROVEMENT 4: Use separated for consistent spacing ---
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
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
  final Widget bottomChip;

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

    return SizedBox(
      width: 190.w,
      child: Hero(
        tag: heroTag,
        child: Card(
          // --- IMPROVEMENT 5: Softer, more modern shadow ---
          elevation: 4,
          shadowColor: colors.shadow.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          clipBehavior: Clip.antiAlias,
          // --- IMPROVEMENT 6: Use InkWell for tap feedback (ripple effect) ---
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5, // Adjusted flex for a larger image area
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // --- IMPROVEMENT 7: Shimmer loading effect for images ---
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer(
                            color: Colors.grey[300]!,
                            child: Container(color: Colors.white),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colors.primary.withOpacity(0.08),
                          child: Icon(
                            Icons.image_not_supported,
                            color: colors.primary.withOpacity(0.5),
                          ),
                        ),
                      ),
                      // --- IMPROVEMENT 8: Favorite Button with better UX ---
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20.sp,
                              color: isFavorite
                                  ? const Color(0xFFFFD93D)
                                  : colors.primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(bottom: 8.h, left: 8.w, child: bottomChip),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3, // Adjusted flex
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: textStyles.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: colors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2, // Allow two lines for longer names
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
  final double rating;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback onTap;

  const _RestaurantCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.isFavorite,
    required this.onTap,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      heroTag: 'favorite_restaurant_$id',
      name: name,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
      onTap: onTap,
      onToggleFavorite: onToggleFavorite,
      bottomChip: _RatingChip(rating: rating),
    );
  }
}

class _FoodCard extends StatelessWidget {
  // ... (properties are the same)
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String priceLabel;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback onTap;

  const _FoodCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.priceLabel,
    required this.isFavorite,
    required this.onTap,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      heroTag: 'favorite_food_$id',
      name: name,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
      onTap: onTap,
      onToggleFavorite: onToggleFavorite,
      // --- IMPROVEMENT 9: Extracted bottom chip to its own widget ---
      bottomChip: _RatingAndPriceChip(rating: rating, priceLabel: priceLabel),
    );
  }
}

// --- IMPROVEMENT 10: Create dedicated widgets for chips for cleaner code ---
class _RatingChip extends StatelessWidget {
  final double rating;
  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingAndPriceChip extends StatelessWidget {
  final double rating;
  final String priceLabel;
  const _RatingAndPriceChip({required this.rating, required this.priceLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            width: 1.5,
            height: 12.h,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(width: 6.w),
          Text(
            priceLabel,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
