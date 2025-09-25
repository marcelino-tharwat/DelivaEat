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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyles.titleLarge?.copyWith(
                color: colors.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05, // Responsive font size
              ),
            ),
          ),
          if (showSeeAll)
            Flexible(
              fit: FlexFit.loose,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => onSeeAllTap(title),
                  icon: Icon(
                    // Respect RTL by flipping the arrow direction
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    size: 14,
                  ),
                  label: Text(
                    appLocalizations.seeAll,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}