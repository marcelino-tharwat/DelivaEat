import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/generated/l10n.dart'; // افترض وجود ملفات الترجمة
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomLinks extends StatelessWidget {
  const BottomLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      children: [
        TextButton(
          onPressed: () { /* منطق نسيت كلمة المرور */ },
          child: Text(
            l10n.forgot_password,
            style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.no_account,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            GestureDetector(
              onTap: () {  context.go(AppRoutes.signupPage); },
              child: Text(
                l10n.create_account,
                style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}