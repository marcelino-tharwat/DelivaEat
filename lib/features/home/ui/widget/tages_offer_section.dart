import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TagsOffersSection extends StatelessWidget {
  final Function(String) onTagTap;

  const TagsOffersSection({super.key, required this.onTagTap});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final tags = [
      {
        'name': appLocalizations.tagDiscounts,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.local_offer,
      },
      {
        'name': appLocalizations.tagNew,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.fiber_new,
      },
      {
        'name': appLocalizations.tagFreeDelivery,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.delivery_dining,
      },
      {
        'name': appLocalizations.tagFast,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.flash_on,
      },
      {
        'name': appLocalizations.tagHealthy,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.eco,
      },
      {
        'name': appLocalizations.tagDrinks,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.local_drink,
      },
      {
        'name': appLocalizations.tagSweets,
        'color': const Color(0xFFFFD93D),
        'icon': Icons.cake,
      },
    ];
    final textStyles = context.textStyles;

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return GestureDetector(
            onTap: () => _handleTagTap(tag['name'] as String, context),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: (tag['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (tag['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tag['icon'] as IconData,
                    size: 16,
                    color: tag['color'] as Color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tag['name'] as String,
                    style: textStyles.bodySmall?.copyWith(
                      color: tag['color'] as Color,
                      fontWeight: FontWeight.w600,
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

  void _handleTagTap(String tag, context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تصفية حسب: $tag',
        ), // Consider adding a localization key for this
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
