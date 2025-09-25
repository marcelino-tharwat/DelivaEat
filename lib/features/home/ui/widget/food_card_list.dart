import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FoodCardList extends StatelessWidget {
  final List<FoodModel> foods;
  final Function(String, int) onFoodCardTap;

  const FoodCardList({super.key, required this.foods, required this.onFoodCardTap});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    if (foods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: screenHeight * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final FoodModel f = foods[index];
          final name = isArabic ? f.nameAr : f.name;
          final imageUrl = f.image;
          final rating = f.rating;
          final priceStr = f.price.toStringAsFixed(0);
          final emoji = '🍽️';

          return _buildFoodCard(
            context,
            name,
            imageUrl,
            rating,
            priceStr,
            emoji,
            index,
          );
        },
      ),
    );
  }

  Widget _buildFoodCard(
    BuildContext context,
    String name,
    String imageUrl,
    double rating,
    String price,
    String emojiFallback,
    int index,
  ) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final screenWidth = MediaQuery.of(context).size.width;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: () => onFoodCardTap(name, index),
      child: Hero(
        tag: 'food_$index',
        child: Container(
          width: screenWidth * 0.48,
          margin: const EdgeInsets.only(right: 16),
          child: Card(
            elevation: 8,
            shadowColor: colors.shadow.withOpacity(0.15),
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
                          child: Center(
                            child: Text(
                              emojiFallback,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
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
                                rating.toString(),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: textStyles.titleSmall?.copyWith(
                                fontSize: screenWidth * 0.04,
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appLocalizations.availableForDelivery,
                              style: textStyles.bodySmall?.copyWith(
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? '$price ريال' : '$price SAR',
                              style: textStyles.titleMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: colors.onPrimary,
                                size: 16,
                              ),
                            ),
                          ],
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