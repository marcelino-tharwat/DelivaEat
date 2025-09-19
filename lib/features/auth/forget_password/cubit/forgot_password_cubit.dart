import 'package:bloc/bloc.dart';
import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_state.dart';
import 'package:deliva_eat/features/auth/forget_password/data/repos/forgot_password_repo.dart';
import 'package:flutter/material.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  // Get the repository instance from GetIt
  ForgotPasswordRepo forgotPasswordRepo;
  ForgotPasswordCubit({required this.forgotPasswordRepo})
    : super(ForgotPasswordInitial());
 TextEditingController emailController = TextEditingController();
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    emit(ForgotPasswordLoading());

    // Call the actual API via the repository
    final result = await forgotPasswordRepo.requestPasswordReset(
      email: email,
      context: context,
    );
    if (isClosed) return;

    result.fold(
      // On Failure
      (failure) => emit(ForgotPasswordFailure(failure.errorMessage)),
      // On Success
      (successResponse) {
        // The backend always returns success=true, so we can just emit the success state
        emit(
          ForgotPasswordSuccess(forgotPasswordSuccessResponse: successResponse),
        );
      },
    );
  }
}
