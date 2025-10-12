import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText; // أصبح اختياريًا
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator; // لقبول validator مخصص
  final int? maxLines; // لدعم الحقول متعددة الأسطر
  final String? errorText;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1, // القيمة الافتراضية هي سطر واحد
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator, // استخدام الـ validator الممرر
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colorScheme.onSurfaceVariant)
            : null,
        suffixIcon: suffixIcon,
      ).applyDefaults(theme.inputDecorationTheme),
    );
  }
}
