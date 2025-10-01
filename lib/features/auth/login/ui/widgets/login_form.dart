
import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:deliva_eat/core/widgets/app_text_field.dart';

import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/auth/login/cubit/login_cubit.dart';
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            email: _emailController.text,
            password: _passwordController.text,
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            l10n.welcome_back,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.login_to_continue,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 40.h),

          // Email
          AppTextField(
            controller: _emailController,
            labelText: l10n.email,
            hintText: 'example@gmail.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                v!.isEmpty ? l10n.error_email_required : null,
          ),
          SizedBox(height: 20.h),

          // Password
          AppTextField(
            controller: _passwordController,
            labelText: l10n.password,
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline,
            isPassword: !_isPasswordVisible,
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
            ),
            validator: (v) =>
                v!.isEmpty ? l10n.error_password_required : null,
          ),
          SizedBox(height: 30.h),

          // Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final loading = state is LoginLoading;
                return AbsorbPointer(
                  absorbing: loading,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: loading ? 0.6 : 1,
                        child: AppButton(text: l10n.login, onPressed: _login),
                      ),
                      if (loading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

