import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/features/auth/otp/data/repo/otp_verify_code.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpVerifyCodeRepository otpVerifyCodeRepository;

  OtpCubit({required this.otpVerifyCodeRepository}) : super(OtpInitial());
  String otp = '';
  Future<void> verifyOtp({
    required String otp,
    required String email,
    required BuildContext context,
  }) async {
    emit(OtpLoading());
    final result = await otpVerifyCodeRepository.verifyCode(
      email: email,
      code: otp,
      context: context,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(OtpFailure(error: failure)),
      (_) => emit(
        OtpSuccess(
          message: AppLocalizations.of(context)!.code_verified_successfully,
        ),
      ),
    );
  }

  Future<void> resendOtp({
    required String email,
    required BuildContext context,
  }) async {
    final result = await otpVerifyCodeRepository.requestPasswordReset(
      email: email,
      context: context,
    );
    result.fold(
      (failure) => emit(OtpFailure(error: failure)),
      (_) => emit(
        OtpResendSuccess(
          message: AppLocalizations.of(context)!.new_code_sent(email),
        ),
      ),
    );
  }
}
