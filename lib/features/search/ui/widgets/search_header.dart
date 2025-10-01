import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchHeader extends StatelessWidget {
  final bool isSearchFocused;
  final VoidCallback onBackPressed;

  const SearchHeader({
    super.key,
    required this.isSearchFocused,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.fromLTRB(
        16.w,
        8.h,
        16.w,
        isSearchFocused ? 8.h : 16.h,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: isSearchFocused
            ? [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackPressed,
                icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                style: IconButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  padding: EdgeInsets.all(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              if (!isSearchFocused) ...[
                Expanded(
                  child: AnimatedOpacity(
                    opacity: isSearchFocused ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      AppLocalizations.of(context)!.searchTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
