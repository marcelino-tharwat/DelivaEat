import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:deliva_eat/core/widgets/app_text_field.dart';
import 'package:deliva_eat/features/auth/new_password/cubit/new_password_cubit.dart';
import 'package:deliva_eat/features/auth/new_password/cubit/new_password_state.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPasswordForm extends StatefulWidget {
  final String? email;
  final String? token;

  const NewPasswordForm({super.key, this.email, this.token});

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<NewPasswordCubit>().resetPassword(
        email: widget.email ?? '',
        code: widget.token ?? '',
        newPassword: _passwordController.text.trim(),
      );
    }
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            l10n.new_password_header, // تم التعديل
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            l10n.new_password_description, // تم التعديل
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey[600],
              height: 1.35,
            ),
          ),
          SizedBox(height: 32.h),

          // New Password Field
          AppTextField(
            controller: _passwordController,
            labelText: l10n.new_password, // تم التعديل
            hintText: l10n.new_password_hint, // تم التعديل
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            isPassword: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.error_password_required; // تم التعديل
              }
              if (!_isPasswordValid(value)) {
                return l10n.error_password_invalid; // تم التعديل
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),

          // Confirm Password Field
          AppTextField(
            controller: _confirmPasswordController,
            labelText: l10n.confirm_password, // تم التعديل
            hintText: l10n.confirm_password_hint, // تم التعديل
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            isPassword: _obscureConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.error_confirm_password_required; // تم التعديل
              }
              if (value != _passwordController.text) {
                return l10n.error_password_mismatch; // تم التعديل
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),

          // Password Requirements
          _buildPasswordRequirements(l10n),
          SizedBox(height: 25.h),

          // Reset Password Button
          SizedBox(
            width: double.infinity,
            height: 49.h,
            child: BlocBuilder<NewPasswordCubit, NewPasswordState>(
              builder: (context, state) {
                final loading = state is NewPasswordLoading;
                return AbsorbPointer(
                  absorbing: loading,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: loading ? 0.6 : 1,
                        child: AppButton(
                          text: l10n.update_password_button, // تم التعديل
                          onPressed: _resetPassword,
                        ),
                      ),
                      if (loading)
                        const SizedBox(
                          width: 19,
                          height: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 18.h),

          // Security Info
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.green[600], size: 19.sp),
                SizedBox(width: 11.w),
                Expanded(
                  child: Text(
                    l10n.new_password_security_info, // تم التعديل
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.green[700],
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements(AppLocalizations l10n) {
    final password = _passwordController.text;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.password_requirements, // تم التعديل
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 7.h),
          _buildRequirement(l10n.errorPasswordMinLength, password.length >= 8), // تم التعديل
          _buildRequirement(
            l10n.errorPasswordUppercase, // تم التعديل
            RegExp(r'[A-Z]').hasMatch(password),
          ),
          _buildRequirement(
            l10n.errorPasswordLowercase, // تم التعديل
            RegExp(r'[a-z]').hasMatch(password),
          ),
          _buildRequirement(
            l10n.errorPasswordNumber, // تم التعديل
            RegExp(r'[0-9]').hasMatch(password),
          ),
          _buildRequirement(
            l10n.errorPasswordSpecialChar, // تم التعديل
            RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 15.sp,
            color: isMet ? Colors.green : Colors.grey[400],
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                color: isMet ? Colors.green[700] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}