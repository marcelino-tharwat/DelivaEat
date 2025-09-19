import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_cubit.dart';
import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_state.dart';
import 'package:deliva_eat/features/auth/forget_password/ui/widgets/forgot_password.form.dart';
import 'package:deliva_eat/features/auth/forget_password/ui/widgets/forgot_password_header.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
  String _translateError(String message, AppLocalizations l10n) {
    if (message.contains("timeout")) return l10n.error_connection_timeout;
    if (message.contains("Connection error")) {
      return l10n.error_connection_error;
    }
    if (message.contains("Bad response")) return l10n.error_internal_server;
    if (message.contains("cancelled")) return l10n.error_request_cancelled;
    return message; // fallback لو الرسالة مش مترجمة عندنا
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            if (state is ForgotPasswordFailure) {
              final message = _translateError(state.errorMessage, l10n);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            }
            if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.forgotPasswordSuccessResponse.data!["message"],
                  ),
                  backgroundColor: Colors.green,
                ),
              );
      context.go(
        AppRoutes.otpPage,
        extra: context.read<ForgotPasswordCubit>().emailController.text.trim(),
      );

              // Navigate back to login after showing success message
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
                const ForgotPasswordHeader(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ForgotPasswordForm(),
                      SizedBox(height: 30.h),
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
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.yellow[700], size: 16),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context)!.back_to_login,
            style: TextStyle(
              color: Colors.yellow[700],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
