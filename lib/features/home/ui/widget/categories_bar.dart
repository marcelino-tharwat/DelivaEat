import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';

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

    return Container(
      height: screenWidth * 0.2, // Reduced from 0.27 to 0.2
      child: PageView.builder(
        controller: pageController,
        padEnds: false,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return LayoutBuilder(
            builder: (context, constraints) {
              final itemHeight = constraints.maxHeight; // height allocated by the PageView item
              // Allocate vertical space percentages that always sum <= 1.0 to avoid overflow
              final cardSize = itemHeight * 0.60; // 60% for the square card
              final gap = itemHeight * 0.05;       // 5% vertical gap
              final textBoxHeight = itemHeight * 0.25; // 25% reserved box for text
              final iconSize = cardSize * 0.55;    // icon fits nicely inside card
              final fontSize = textBoxHeight * 0.45; // text size proportional to its box

              return GestureDetector(
                onTap: () => onCategoryTap(category),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4), // compact side margin
                  child: SizedBox(
                    height: itemHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: cardSize,
                          height: cardSize,
                          child: Card(
                          elevation: 2,
                          shadowColor: colors.shadow.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          color: colors.surface,
                          child: Center(
                            child: Icon(
                              category['icon'],
                              size: iconSize,
                              color: category['color'],
                            ),
                          ),
                        ),
                        ),
                        SizedBox(height: gap),
                        SizedBox(
                          height: textBoxHeight,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: cardSize * 1.1),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                category['name'],
                                textAlign: TextAlign.center,
                                style: textStyles.bodySmall?.copyWith(
                                  color: colors.onBackground,
                                  fontWeight: FontWeight.w600,
                                  fontSize: fontSize.clamp(8.0, 16.0),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}