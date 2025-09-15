import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/core/auth/google_auth.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          onTap: () => _onGooglePressed(context),
          assetPath: 'assets/images/google_logo.png',
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          onTap: () {},
          assetPath: 'assets/images/facebook_logo.png',
        ),
      ],
    );
  }

  Widget _buildSocialButton({required VoidCallback onTap, required String assetPath}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: Image.asset(assetPath, height: 30.h, width: 30.w)),
      ),
    );
  }

  Future<void> _onGooglePressed(BuildContext context) async {
    try {
      final res = await GoogleAuthService.signInAndExchangeToken();
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول بجوجل بنجاح'), backgroundColor: Colors.green),
        );
        // TODO: احفظ التوكن res['data']['token'] وانتقل للصفحة الرئيسية
      } else {
        final msg = (res['error']?['message'] ?? 'فشل تسجيل الدخول بجوجل').toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}