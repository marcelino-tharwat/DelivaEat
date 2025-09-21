import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final screenHeight = MediaQuery.of(context).size.height;

    final navBarHeight = (screenHeight * 0.09).clamp(70.0, 90.0);

    return Container(
      height: navBarHeight,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(appLocalizations.homePageTitle, Icons.home_rounded, 0, context),
            _buildNavItem(appLocalizations.ordersTitle, Icons.receipt_long_rounded, 1, context),
            _buildNavItem(appLocalizations.offersTitle, Icons.local_offer_rounded, 2, context),
            _buildNavItem(appLocalizations.accountTitle, Icons.person_rounded, 3, context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, int index, BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                Icon(
                  icon,
                  color: isSelected
                      ? colors.primary
                      : colors.onSurface.withOpacity(0.6),
                  size: isSelected ? 26 : 24,
                ),
              ],
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style:
                  textStyles.bodySmall?.copyWith(
                    color: isSelected
                        ? colors.primary
                        : colors.onSurface.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: isSelected ? 11 : 10,
                  ) ??
                  const TextStyle(),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}