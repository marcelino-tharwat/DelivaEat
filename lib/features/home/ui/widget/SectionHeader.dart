import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final IconData? icon;
  final Color? iconColor;
  final Function(String) onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.showSeeAll = true,
    this.icon,
    this.iconColor,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 ده المفتاح
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 👈 العنوان (و الأيقونة لو موجودة)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? colors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? colors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyles.titleLarge?.copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ],
          ),

          // 👈 زرار الـ See All
          if (showSeeAll)
            TextButton(
              onPressed: () => onSeeAllTap(title),
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(appLocalizations.seeAll),
                  const SizedBox(width: 4),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios,
                    size: 14,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
