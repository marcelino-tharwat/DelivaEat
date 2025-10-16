import 'package:deliva_eat/core/theme/app_colors.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/home/cubit/home_cubit.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  final List<RestaurantModel> favoriteRestaurants;
  final List<FoodModel> favoriteFoods;

  const FavoritesPage({
    super.key,
    required this.favoriteRestaurants,
    required this.favoriteFoods,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<RestaurantModel> favRestaurants = favoriteRestaurants;
    List<FoodModel> favFoods = favoriteFoods;
    final state = context.watch<HomeCubit>().state;
    if (state is HomeSuccess) {
      favRestaurants = state.favoriteRestaurants;
      favFoods = state.favoriteFoods;
    }
    final allItems = [...favRestaurants, ...favFoods];

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface, // Use a slightly different background
      body: SafeArea(
        // Using CustomScrollView for better performance and scroll effects
        child: CustomScrollView(
          slivers: [
            // SliverAppBar provides a modern, collapsible app bar
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              pinned: true,
              centerTitle: true,
              leading: Center(
                child: InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20.sp,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.favoritesTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            // Show empty state if there are no favorite items
            if (allItems.isEmpty)
              _buildEmptyState(context)
            else
              // Build the list of favorite items
              _buildFavoritesList(allItems),
          ],
        ),
      ),
    );
  }

  // A dedicated widget for the empty state for better readability
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    // Use SliverToBoxAdapter to place a non-sliver widget inside a CustomScrollView
    return SliverToBoxAdapter(
      child: Container(
        // Calculate height to center the content vertically
        height: MediaQuery.of(context).size.height * 0.6,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline, // Using outline icon for empty state
              size: 100.sp,
              color: theme.hintColor.withOpacity(0.5),
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.noFavoriteItems,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.hintColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppLocalizations.of(context)!.addFavoriteItemsHint,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A dedicated widget for building the list
  Widget _buildFavoritesList(List<dynamic> allItems) {
    // SliverList is the efficient way to build lists inside a CustomScrollView
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = allItems[index];
          if (item is RestaurantModel) {
            return _buildRestaurantCard(context, item);
          } else if (item is FoodModel) {
            return _buildFoodCard(context, item);
          }
          return const SizedBox.shrink();
        }, childCount: allItems.length),
      ),
    );
  }

  // A generic card widget to reduce code duplication
  Widget _buildFavoriteItemCard({
    required BuildContext context,
    required String imageUrl,
    required String heroTag,
    required String title,
    required Widget subtitle,
    required VoidCallback onTap,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.h),
      shadowColor: theme.shadowColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    imageUrl,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80.w,
                      height: 80.h,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey[400],
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    subtitle,
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  // Updated restaurant card using the generic card widget
  Widget _buildRestaurantCard(
    BuildContext context,
    RestaurantModel restaurant,
  ) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName =
        (isArabic ? restaurant.nameAr : restaurant.name) ?? 'مطعم';

    return _buildFavoriteItemCard(
      context: context,
      imageUrl: restaurant.image,
      heroTag: 'favorites_restaurant_${restaurant.id}',
      title: displayName,
      onTap: () => context.push(
        AppRoutes.restaurantPage,
        extra: {'restaurantId': restaurant.id, 'restaurantName': displayName},
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.star_rate_rounded,
            color: Colors.amber.shade600,
            size: 18.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            restaurant.rating?.toStringAsFixed(1) ?? 'N/A',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.timer_outlined, color: Colors.grey[600], size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            restaurant.deliveryTime ?? 'غير محدد',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          final isAr = Localizations.localeOf(context).languageCode == 'ar';
          context.read<HomeCubit>().toggleFavorite(
            restaurantId: restaurant.id.toString(),
            lang: isAr ? 'ar' : 'en',
            baseOverride: restaurant,
          );
        },
        icon: Icon(
          (restaurant.isFavorite ?? false)
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: (restaurant.isFavorite ?? false)
              ? AppColors.primary
              : theme.colorScheme.primary,
          size: 24.sp,
        ),
      ),
    );
  }

  // Updated food card using the generic card widget
  Widget _buildFoodCard(BuildContext context, FoodModel food) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = (isArabic ? food.nameAr : food.name) ?? 'طعام';
    final priceStr = food.price?.toStringAsFixed(0) ?? '0';

    return _buildFavoriteItemCard(
      context: context,
      imageUrl: food.image,
      heroTag: 'favorites_food_${food.id}',
      title: displayName,
      onTap: () {
        context.push(
          AppRoutes.productDetailsPage,
          extra: {
            'foodId': food.id.toString(),
            'title': displayName,
            'image': food.image,
            'price': priceStr,
            'isFavorite': food.isFavorite ?? false,
          },
        );
      },
      subtitle: Row(
        children: [
          Icon(
            Icons.star_rate_rounded,
            color: Colors.amber.shade600,
            size: 18.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            food.rating?.toStringAsFixed(1) ?? 'N/A',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            isArabic ? '$priceStr ريال' : '$priceStr SAR',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          final isAr = Localizations.localeOf(context).languageCode == 'ar';
          context.read<HomeCubit>().toggleFoodFavorite(
            foodId: food.id.toString(),
            lang: isAr ? 'ar' : 'en',
          );
        },
        icon: Icon(
          (food.isFavorite ?? false)
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: (food.isFavorite ?? false)
              ? AppColors.primary
              : theme.colorScheme.primary,
          size: 24.sp,
        ),
      ),
    );
  }
}
