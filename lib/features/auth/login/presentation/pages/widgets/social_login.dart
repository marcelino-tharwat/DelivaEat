import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          onTap: () { /* منطق Google */ },
          assetPath: 'assets/images/google_logo.png',
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          onTap: () { /* منطق Facebook */ },
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
}