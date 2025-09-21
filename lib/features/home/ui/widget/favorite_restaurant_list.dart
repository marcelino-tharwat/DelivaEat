import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';

class FavoriteRestaurantsList extends StatelessWidget {
  final Function(String, int) onRestaurantTap;

  const FavoriteRestaurantsList({super.key, required this.onRestaurantTap});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16), // Added horizontal padding
        itemCount: 4,
        itemBuilder: (context, index) {
          final restaurants = [
            {
              'name': 'مطعم النور',
              'rating': '4.8',
              'image': 'assets/restaurant_1.jpg',
            },
            {
              'name': 'برجر ستيشن',
              'rating': '4.6',
              'image': 'assets/restaurant_2.jpg',
            },
            {
              'name': 'سوشي هاوس',
              'rating': '4.9',
              'image': 'assets/restaurant_3.jpg',
            },
            {
              'name': 'كافيه السعادة',
              'rating': '4.5',
              'image': 'assets/restaurant_4.jpg',
            },
          ];

          return _buildFavoriteCard(
            context,
            restaurants[index]['name']!,
            restaurants[index]['rating']!,
            restaurants[index]['image']!,
            index,
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    String name,
    String rating,
    String imagePath,
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
                      Image.asset(
                        imagePath,
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
                                rating,
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