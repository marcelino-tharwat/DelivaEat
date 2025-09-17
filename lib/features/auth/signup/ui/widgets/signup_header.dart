import 'package:deliva_eat/core/theme/app_colors.dart';
import 'package:deliva_eat/generated/l10n.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('DelivaEat', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8.h),
          Text(l10n.create_account, style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}