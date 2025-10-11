import 'package:deliva_eat/features/auth/login/ui/widgets/button_links.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/login_form.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/login_header.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/or_divider.dart';
import 'package:deliva_eat/features/auth/login/ui/widgets/social_login.dart';
import 'package:deliva_eat/core/auth/token_storage.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/auth/login/cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
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
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            if (state is LoginFailure) {
              final message = _translateError(state.errorMessage, l10n);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            }
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              final token = state.authResponse.data?.token;
              if (token != null && token.isNotEmpty) {
                // persist token for authenticated requests
                TokenStorage.setToken(token);
              }
              // Navigate here if you want:
              // Navigator.pushReplacementNamed(context, "/home");
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                LoginHeader(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoginForm(),
                      SizedBox(height: 30.h),
                      const OrDivider(),
                      SizedBox(height: 10.h),
                      const SocialLoginButtons(),
                      SizedBox(height: 10.h),
                      const BottomLinks(),
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
}
