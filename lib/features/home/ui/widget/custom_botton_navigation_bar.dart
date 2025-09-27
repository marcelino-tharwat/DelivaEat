import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    // استخدم .h بدلاً من MediaQuery
    final navBarHeight = (80.h).clamp(60.h, 90.h); 

    return Container(
      height: navBarHeight,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.2),
            blurRadius: 20.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
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
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Container(
                      width: 32.w,
                      height: 32.w,
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
                    size: isSelected ? 24.sp : 22.sp,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: textStyles.bodySmall?.copyWith(
                      color: isSelected
                          ? colors.primary
                          : colors.onSurface.withOpacity(0.6),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: isSelected ? 10.sp : 9.sp,
                    ) ??
                    const TextStyle(),
                child: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
