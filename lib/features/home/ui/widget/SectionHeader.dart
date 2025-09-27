import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // متجاوبة
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 👈 العنوان (و الأيقونة لو موجودة)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: (iconColor ?? colors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? colors.primary,
                    size: 20.sp, // متجاوب
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyles.titleLarge?.copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp, // متجاوب بدل screenWidth * 0.05
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
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                minimumSize: Size(0, 36.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    appLocalizations.seeAll,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
