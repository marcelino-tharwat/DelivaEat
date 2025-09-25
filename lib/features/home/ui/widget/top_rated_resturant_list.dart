import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TopRatedRestaurantsList extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final Function(Map<String, dynamic>, int) onRestaurantDetailTap;
  final Function(Map<String, dynamic>) onViewMenuTap;

  const TopRatedRestaurantsList({
    super.key,
    required this.restaurants,
    required this.onRestaurantDetailTap,
    required this.onViewMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: screenHeight * 0.35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final RestaurantModel r = restaurants[index];
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final Map<String, dynamic> item = {
            'name': isArabic ? r.nameAr : r.name,
            'rating': r.rating.toStringAsFixed(1),
            'avgPrice': '',
            'emoji': '🍽️',
            'image': r.image,
            'deliveryTime': r.deliveryTime,
            'specialty': '',
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
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onRestaurantDetailTap(restaurant, index),
      child: Hero(
        tag: 'top_restaurant_$index',
        child: Container(
          width: screenWidth * 0.55,
          margin: const EdgeInsets.only(right: 16),
          child: Card(
            elevation: 10,
            shadowColor: colors.shadow.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
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
                                    style: const TextStyle(fontSize: 50),
                                  ),
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            restaurant['specialty'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                restaurant['rating'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
                    padding: const EdgeInsets.all(10),
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
                                fontSize: screenWidth * 0.04,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: colors.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    restaurant['deliveryTime'],
                                    style: textStyles.bodySmall?.copyWith(
                                      color: colors.onSurface.withOpacity(0.6),
                                      fontSize: screenWidth * 0.03,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant['avgPrice'],
                              style: textStyles.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => onViewMenuTap(restaurant),
                            icon: const Icon(Icons.restaurant_menu, size: 16),
                            label: Text(appLocalizations.viewMenu),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 6),
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