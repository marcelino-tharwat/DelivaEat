part of 'otp_cubit.dart';

abstract class OtpState {}
class OtpInitial extends OtpState {}
class OtpLoading extends OtpState {}
class OtpSuccess extends OtpState {
  final String message;
  OtpSuccess({required this.message});
}
class OtpFailure extends OtpState {
  final ApiErrorHandler error;
  OtpFailure({required this.error});
}
class OtpResendSuccess extends OtpState {
  final String message;
  OtpResendSuccess({required this.message});
}