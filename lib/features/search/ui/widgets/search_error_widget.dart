import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SearchErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48.sp,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.errorOccurred,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 18.sp),
              label: Text(AppLocalizations.of(context)!.retry),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
