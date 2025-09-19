import 'package:deliva_eat/core/regex/app_regex.dart';
import 'package:deliva_eat/core/widgets/app_text_field.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicInfoSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  const BasicInfoSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
  });

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.basic_info_title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),

        // Full Name
        AppTextField(
          controller: widget.nameController,
          labelText: l10n.full_name,
          prefixIcon: Icons.person,
          validator: (v) => v!.isEmpty ? l10n.error_name_required : null,
        ),
        SizedBox(height: 16.h),

        // Email
        AppTextField(
          controller: widget.emailController,
          labelText: l10n.email,
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (v) => v!.isEmpty
              ? l10n.error_email_required
              : !AppRegex.isValidEmail(v)
              ? l10n.reset_password_invalid_email
              : null,
        ),
        SizedBox(height: 16.h),

        // Password
        AppTextField(
          controller: widget.passwordController,
          labelText: l10n.password,
          prefixIcon: Icons.lock,
          isPassword: !_passwordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return l10n.errorPasswordRequired;
            if (!AppRegex.hasLowercase(v)) return l10n.errorPasswordLowercase;
            if (!AppRegex.hasUppercase(v)) return l10n.errorPasswordUppercase;
            if (!AppRegex.hasNumber(v)) return l10n.errorPasswordNumber;
            if (!AppRegex.hasSpecialCharacter(v)) {
              return l10n.errorPasswordSpecialChar;
            }
            if (!AppRegex.hasMinLength(v)) return l10n.errorPasswordMinLength;
            return null; // كلمة المرور صحيحة
          },
        ),
        SizedBox(height: 16.h),

        // Phone
        AppTextField(
          controller: widget.phoneController,
          labelText: l10n.phone_number,
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (v) => v!.isEmpty ? l10n.error_phone_required : null,
        ),
      ],
    );
  }
}
