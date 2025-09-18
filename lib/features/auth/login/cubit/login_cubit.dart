import 'package:bloc/bloc.dart';
import 'package:deliva_eat/features/auth/login/data/models/auth_response.dart';
import 'package:meta/meta.dart';
import 'package:deliva_eat/features/auth/login/data/models/login_req_model.dart';
import 'package:deliva_eat/features/auth/login/data/repos/login_repo.dart';
import 'package:flutter/widgets.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;

  LoginCubit({required this.loginRepo}) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoading());
    final loginReqModel = LoginReqModel(email, password);
    final result = await loginRepo.login(loginReqModel: loginReqModel, context: context);
    result.fold(
      (error) => emit(LoginFailure(error.errorMessage)),
      (authResponse) => emit(LoginSuccess(authResponse)),
    );
  }
}
