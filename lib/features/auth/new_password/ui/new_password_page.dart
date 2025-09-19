import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/auth/new_password/cubit/new_password_cubit.dart';
import 'package:deliva_eat/features/auth/new_password/cubit/new_password_state.dart';
import 'package:deliva_eat/features/auth/new_password/ui/widget/new_password_form.dart';
import 'package:deliva_eat/features/auth/new_password/ui/widget/new_password_header.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewPasswordPage extends StatelessWidget {
  final String? email;
  final String? token;

  const NewPasswordPage({super.key, this.email, this.token});

  // تم تعديل هذه الدالة لتستخدم l10n
  String _translateError(String message, AppLocalizations l10n) {
    if (message.contains("timeout")) return l10n.error_connection_timeout;
    if (message.contains("Connection error")) {
      return l10n.error_connection_error;
    }
    if (message.contains("Bad response")) return l10n.error_internal_server;
    if (message.contains("cancelled")) return l10n.error_request_cancelled;
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: BlocConsumer<NewPasswordCubit, NewPasswordState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            if (state is NewPasswordFailure) {
              final message = _translateError(state.errorMessage, l10n);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );

              if (state.errorMessage.contains("Token expired") ||
                  state.errorMessage.contains("Invalid token")) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) {
                    context.go(AppRoutes.forgetPasswordPage);
                  }
                });
              }
            }

            if (state is NewPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.password_reset_success), // تم التعديل
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );

              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const NewPasswordHeader(),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NewPasswordForm(email: email, token: token),
                      SizedBox(height: 27.h),
                      _buildBackToLoginButton(context),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // إضافة هذه السطر

    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.yellow[700], size: 15),
          const SizedBox(width: 4),
          Text(
            l10n.back_to_login, // تم التعديل
            style: TextStyle(
              color: Colors.yellow[700],
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }
}
