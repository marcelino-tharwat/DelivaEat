import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:deliva_eat/core/widgets/app_text_field.dart';
import 'package:deliva_eat/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
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

          
          AppTextField(
            controller: _emailController,
            labelText: l10n.email,
            hintText: 'example@gmail.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 20.h),

          
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
          ),
          SizedBox(height: 30.h),

          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: AppButton(text: l10n.login, onPressed: _login),
          ),
        ],
      ),
    );
  }
}
