
import 'package:deliva_eat/generated/l10n.dart';
import 'package:flutter/material.dart';

class SignupBottomLinks extends StatelessWidget {
  const SignupBottomLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(l10n.signup_already_have_account),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child:  Text(
              l10n.login,
              style: TextStyle(
                color: Color(0xFFF5C842),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}