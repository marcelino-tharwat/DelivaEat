import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final allItems = [...favoriteRestaurants, ...favoriteFoods];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea( // <--- أضف SafeArea هنا
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title and back button like category page
              Padding(
                // يمكنك تقليل هذا الـ top أو ضبطه بناءً على statusBarHeight إذا أردت تحكمًا دقيقًا
                // For now, let's try a smaller fixed value or remove it if SafeArea handles status bar
                padding: const EdgeInsets.only(top: 10, left: 16, right: 16 , bottom: 0) , // قللنا الـ top هنا
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Icon(Icons.arrow_back_ios_new, size: 20, color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ),
                    Text( // Moved Text after Align for better Z-order logic, though it doesn't matter for center alignment
                      'المفضلة',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0), // تأكد أن هذا 0
              allItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, size: 80, color: theme.hintColor),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد عناصر مفضلة',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allItems.length,
                        itemBuilder: (context, index) {
                          final item = allItems[index];
                          if (item is RestaurantModel) {
                            return _buildRestaurantCard(context, item);
                          } else if (item is FoodModel) {
                            return _buildFoodCard(context, item as FoodModel);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  // ... (_buildRestaurantCard and _buildFoodCard remain the same)
  Widget _buildRestaurantCard(BuildContext context, RestaurantModel restaurant) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = (isArabic ? restaurant.nameAr : restaurant.name) ?? 'مطعم';
    final ratingStr = restaurant.rating?.toStringAsFixed(1) ?? '0.0';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to restaurant menu
            context.push('/restaurant-menu/${restaurant.id}', extra: displayName);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'favorites_restaurant_${restaurant.id}',
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        restaurant.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.restaurant,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            ratingStr,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.deliveryTime ?? 'غير محدد',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, FoodModel food) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = (isArabic ? food.nameAr : food.name) ?? 'طعام';
    final priceStr = food.price?.toStringAsFixed(0) ?? '0';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle food tap, perhaps show details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'favorites_food_${food.id}',
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        food.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            food.rating?.toStringAsFixed(1) ?? '0.0',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isArabic ? '$priceStr ريال' : '$priceStr SAR',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}