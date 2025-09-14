import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText; // أصبح اختياريًا
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator; // لقبول validator مخصص
  final int? maxLines; // لدعم الحقول متعددة الأسطر

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1, // القيمة الافتراضية هي سطر واحد
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator, // استخدام الـ validator الممرر
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: const Color(0xFFF5C842)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        // مطابقة التصميم الأصلي
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFF5C842), width: 2.w),
        ),
      ),
    );
  }
}