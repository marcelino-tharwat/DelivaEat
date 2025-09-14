// lib/features/signup/presentation/widgets/role_selector_section.dart
import 'package:deliva_eat/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleSelectorSection extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String?> onRoleChanged;

  const RoleSelectorSection({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           l10n.role_selector_title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          ...[l10n.role_user, l10n.role_rider, l10n.role_merchant].map((role) {
            return RadioListTile<String>(
              title: Text(role, style: TextStyle(fontSize: 14.sp)),
              value: role,
              groupValue: selectedRole,
              onChanged: onRoleChanged,
              activeColor: const Color(0xFFF5C842),
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }
}
