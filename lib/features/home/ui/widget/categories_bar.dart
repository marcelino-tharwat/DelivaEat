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

    return SizedBox(
      height: screenWidth * 0.27,
      child: PageView.builder(
        controller: pageController,
        padEnds: false,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final imageUrl = category['image'] as String?;
          final isNetworkImage = imageUrl?.startsWith('http') ?? false;

          return GestureDetector(
            onTap: () => context.go(AppRoutes.categoryPage, extra: category['name']),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shadowColor: colors.shadow.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: double.infinity,
                      height: screenWidth * 0.16,
                      color: colors.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (imageUrl != null)
                            ? (isNetworkImage
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.category),
                                  )
                                : Image.asset(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.category),
                                  ))
                            : const Icon(Icons.category),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: textStyles.bodySmall?.copyWith(
                      color: colors.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.03,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}