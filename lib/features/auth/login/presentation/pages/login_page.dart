import 'package:deliva_eat/features/auth/login/presentation/pages/widgets/button_links.dart';
import 'package:deliva_eat/features/auth/login/presentation/pages/widgets/login_form.dart';
import 'package:deliva_eat/features/auth/login/presentation/pages/widgets/login_header.dart';
import 'package:deliva_eat/features/auth/login/presentation/pages/widgets/or_divider.dart';
import 'package:deliva_eat/features/auth/login/presentation/pages/widgets/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الجزء الأول: الهيدر المنحني
            LoginHeader(),
            
            // الجزء الثاني: محتوى الصفحة مع الـ Padding
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  // فورم تسجيل الدخول (يحتوي على الحقول والزر)
                  LoginForm(),
                  SizedBox(height: 30.h),
                  // فاصل "أو"
                  OrDivider(),
                  SizedBox(height: 30.h),
                  // أزرار الدخول عبر الشبكات الاجتماعية
                  SocialLoginButtons(),
                  SizedBox(height: 40.h),
                  // الروابط السفلية (نسيت كلمة المرور وإنشاء حساب)
                  BottomLinks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}