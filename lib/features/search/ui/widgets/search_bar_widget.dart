import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSearchFocused;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isSearchFocused,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchRestaurantsFoodsHint,
          hintStyle: TextStyle(color: theme.hintColor, fontSize: 14.sp),
          prefixIcon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.search,
              color: isSearchFocused ? theme.primaryColor : theme.hintColor,
              size: 24.sp,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.hintColor,
                      size: 20.sp,
                    ),
                    onPressed: onClear,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: theme.dividerColor, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: theme.primaryColor, width: 2.w),
          ),
          filled: true,
          fillColor: theme.cardColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
