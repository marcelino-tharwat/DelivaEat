import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/auth/otp/cubit/otp_cubit.dart';
import 'package:deliva_eat/features/auth/otp/ui/widget/otp_from.dart';
import 'package:deliva_eat/features/auth/otp/ui/widget/otp_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart'; // تأكد من أن هذا المسار صحيح

class OtpPage extends StatelessWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  String _getLocalizedErrorMessage(String key, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (key) {
      case 'error_connection_timeout':
        return loc.error_connection_timeout;
      case 'error_send_timeout':
        return loc.error_send_timeout;
      case 'error_receive_timeout':
        return loc.error_receive_timeout;
      case 'error_bad_certificate':
        return loc.error_bad_certificate;
      case 'error_request_cancelled':
        return loc.error_request_cancelled;
      case 'error_connection_error':
        return loc.error_connection_error;
      case 'error_not_found':
        return loc.error_not_found;
      case 'error_internal_server':
        return loc.error_internal_server;
      case 'error_processing_response':
        return loc.error_processing_response;
      case 'error_unknown':
        return loc.error_unknown;
      default:
        return key; // إذا لم يكن مفتاحًا، فهو رسالة مباشرة من الـ API
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OtpCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF9F9F9),
        body: SingleChildScrollView(
          child: BlocConsumer<OtpCubit, OtpState>(
            listener: (context, state) {
              final l10n = AppLocalizations.of(context)!;

              if (state is OtpFailure) {
                String rawMessage;

                if (state.error is ServerError) {
                  rawMessage = (state.error as ServerError).errorMessage;
                } else {
                  rawMessage = state.error.toString(); // fallback
                }

                final localizedMessage = _getLocalizedErrorMessage(
                  rawMessage,
                  context,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizedMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is OtpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                // TODO: Navigate to the next screen (e.g., Reset Password)
                context.go(
                  AppRoutes.newPasswordPage,
                  extra: {'email': email, 'otp': context.read<OtpCubit>().otp},
                );
              }
              if (state is OtpResendSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const OtpHeader(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OtpForm(email: email),
                        SizedBox(height: 30.h),
                        _buildBackButton(context),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.yellow[700], size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            AppLocalizations.of(context)!.back_to_previous,
            style: TextStyle(
              color: Colors.yellow[700],
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
