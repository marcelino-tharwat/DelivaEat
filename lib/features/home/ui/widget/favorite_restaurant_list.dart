import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:flutter/material.dart';

class FavoriteRestaurantsList extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final Function(String, int) onRestaurantTap;

  const FavoriteRestaurantsList({super.key, required this.restaurants, required this.onRestaurantTap});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: screenHeight * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16), // Added horizontal padding
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final RestaurantModel r = restaurants[index];
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final displayName = isArabic ? r.nameAr : r.name;
          final ratingStr = r.rating.toStringAsFixed(1);
          final imageUrl = r.image;

          return _buildFavoriteCard(
            context,
            displayName,
            ratingStr,
            imageUrl,
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
    int index,
  ) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onRestaurantTap(name, index),
      child: Hero(
        tag: 'restaurant_$index',
        child: Container(
          width: screenWidth * 0.32,
          margin: const EdgeInsets.only(right: 16), // Added margin to separate cards
          child: Card(
            elevation: 6,
            shadowColor: colors.shadow.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: textStyles.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.032,
                            color: colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                ratingStr,
                                style: textStyles.bodySmall?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
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