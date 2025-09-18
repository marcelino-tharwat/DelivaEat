import 'package:deliva_eat/features/auth/forget_password/data/model/forgot_password_req_model.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordSuccessResponse  forgotPasswordSuccessResponse;

  ForgotPasswordSuccess({required this.forgotPasswordSuccessResponse});
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  final String errorMessage;

  ForgotPasswordFailure(this.errorMessage);
}
