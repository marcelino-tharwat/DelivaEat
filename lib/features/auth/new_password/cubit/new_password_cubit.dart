import 'package:deliva_eat/features/auth/new_password/cubit/new_password_state.dart';
import 'package:deliva_eat/features/auth/new_password/data/model/reset_password_request_body.dart';
import 'package:deliva_eat/features/auth/new_password/data/repo/new_password_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  final NewPasswordRepo _newPasswordRepo;

  NewPasswordCubit(this._newPasswordRepo)
    : super(NewPasswordInitial());

  // لاحظ أن هذه الدالة لا تحتوي على confirmPassword أو context
  void resetPassword({
    required String email,
    required String code, // تتوقع 'code' وليس 'token'
    required String newPassword,
  }) async {
    emit(NewPasswordLoading());

    final requestBody = ResetPasswordRequestBody(
      email: email,
      code: code,
      newPassword: newPassword,
    );
    final result = await _newPasswordRepo.resetPassword(requestBody);

    result.fold(
      (failure) {
        emit(
          NewPasswordFailure(errorMessage: failure.errorMessage),
        );
      },
      (successData) {
        emit(NewPasswordSuccess());
      },
    );
  }
}