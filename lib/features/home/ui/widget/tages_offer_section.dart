import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return SizedBox(
      height: 40.h, // 👈 متجاوبة
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return GestureDetector(
            onTap: () => _handleTagTap(tag['name'] as String, context),
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: (tag['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: (tag['color'] as Color).withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tag['icon'] as IconData,
                    size: 16.sp, // 👈 متجاوبة
                    color: tag['color'] as Color,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    tag['name'] as String,
                    style: textStyles.bodySmall?.copyWith(
                      fontSize: 12.sp,
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
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تصفية حسب: $tag'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r), // 👈 متجاوبة
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
