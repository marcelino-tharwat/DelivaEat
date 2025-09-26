import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CategoriesBar extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final PageController pageController;
  final Function(Map<String, dynamic>) onCategoryTap;

  const CategoriesBar({
    super.key,
    required this.categories,
    required this.pageController,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final labelFontSize = (screenWidth * 0.026).clamp(9.0, 12.0);
    // Provide a fixed, bounded height for the horizontal list
    final double imageAreaHeight = 70; // slightly smaller to avoid overflow on small devices
    final double barHeight = imageAreaHeight + 32; // include label + spacing

    return SizedBox(
      height: barHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final category = categories[index];
          final imageUrl = category['image'] as String?;
          final isNetworkImage = imageUrl?.startsWith('http') ?? false;

          return SizedBox(
            width: 96, // fixed item width for consistent layout
            child: GestureDetector(
              onTap: () => context.go(
                AppRoutes.categoryPage,
                extra: {
                  'id': category['id'],
                  'title': category['name'],
                },
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    shadowColor: colors.shadow.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: double.infinity,
                      height: imageAreaHeight,
                      child: Container(
                        color: colors.surface,
                        padding: const EdgeInsets.all(6.0),
                        child: _buildCategoryImage(imageUrl, isNetworkImage),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 18,
                    child: Center(
                      child: Text(
                        category['name'] ?? '',
                        textAlign: TextAlign.center,
                        style: textStyles.bodySmall?.copyWith(
                          color: colors.onBackground,
                          fontWeight: FontWeight.w600,
                          fontSize: labelFontSize.toDouble(),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryImage(String? imageUrl, bool isNetworkImage) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.category);
    }

    return isNetworkImage
        ? Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.category),
          )
        : Image.asset(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.category),
          );
  }
}