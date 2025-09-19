import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            AppLocalizations.of(context)!.or_continue_with,
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500 ,fontSize: 14.sp),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
      ],
    );
  }
}