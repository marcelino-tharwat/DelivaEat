import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class PopularSearches extends StatelessWidget {
  final PopularSearchesSuccess state;
  final Function(String) onSearchTap;

  const PopularSearches({
    super.key,
    required this.state,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  AppLocalizations.of(context)!.popularSearch,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: state.popularSearches
                  .map(
                    (search) => InkWell(
                      onTap: () => onSearchTap(search.term),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 16.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              search.term,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
