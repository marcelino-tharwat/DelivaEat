import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchLoading extends StatelessWidget {
  const SearchLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.searching,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
