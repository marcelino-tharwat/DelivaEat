import 'package:deliva_eat/features/auth/login/ui/widgets/button_links.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/login_form.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/login_header.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/or_divider.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LoginHeader(),
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginForm(),
                    SizedBox(height: 30.h),
                    OrDivider(),
                    SizedBox(height: 10.h),
                    SocialLoginButtons(),
                    SizedBox(height: 10.h),
                    BottomLinks(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}