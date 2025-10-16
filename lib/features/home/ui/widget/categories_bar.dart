import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesBar extends StatelessWidget {
  final List<Map<String, String>> categories;
  final PageController pageController;
  final Function(Map<String, String>) onCategoryTap;

  const CategoriesBar({
    super.key,
    required this.categories,
    required this.pageController,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    // استخدم ScreenUtil بدلاً من MediaQuery
    final double imageAreaHeight = 70.h;
    final double barHeight = imageAreaHeight + 50.h;

    return SizedBox(
      height: barHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 0.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final imageUrl = category['image'] as String?;
          final isNetworkImage = imageUrl?.startsWith('http') ?? false;

          return SizedBox(
            width: 110.w, // استعمل .w عشان يتناسب مع عرض الشاشة
            // height: 200.h,
            child: GestureDetector(
              onTap: () => onCategoryTap(category),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    shadowColor: colors.shadow.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: double.infinity,
                      height: imageAreaHeight,
                      child: Container(
                        color: colors.surface,
                        // padding: EdgeInsets.all(6.0.w),
                        child: _buildCategoryImage(imageUrl, isNetworkImage),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    height: 20.h,
                    child: Center(
                      child: Text(
                        category['name'] ?? '',
                        textAlign: TextAlign.center,
                        style: textStyles.bodySmall?.copyWith(
                          color: colors.background,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp, // ديناميكي مع الشاشة
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
      return Icon(Icons.category, size: 24.sp);
    }

    return isNetworkImage
        ? Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.category, size: 24.sp),
          )
        : Image.asset(
            imageUrl,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.category, size: 24.sp),
          );
  }
}
