import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_cubit.dart';
import 'package:deliva_eat/features/auth/forget_password/data/repos/forgot_password_repo.dart';
import 'package:deliva_eat/features/auth/login/cubit/login_cubit.dart';
import 'package:deliva_eat/features/auth/new_password/cubit/new_password_cubit.dart';
import 'package:deliva_eat/features/auth/new_password/data/repo/new_password_repo.dart';
import 'package:deliva_eat/features/auth/otp/cubit/otp_cubit.dart';
import 'package:deliva_eat/features/auth/otp/data/repo/otp_verify_code.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:deliva_eat/core/network/dio_factory.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/features/auth/login/data/repos/login_repo.dart';
import 'package:deliva_eat/features/auth/signup/data/repos/signup_repo.dart';
import 'package:deliva_eat/features/auth/signup/cubit/signup_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  Dio dio = DioFactory.getDio();
  //api service
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio, baseUrl: ApiConstant.baseUrl));
  //LOGIN
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(apiService: getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(loginRepo: getIt()));
  // SIGNUP
  getIt.registerLazySingleton<SignupRepo>(
    () => SignupRepo(dio, apiService: getIt()),
  );
  getIt.registerFactory<SignupCubit>(() => SignupCubit(signupRepo: getIt()));
  //FORGOT PASSWORD
  getIt.registerLazySingleton<ForgotPasswordRepo>(
    () => ForgotPasswordRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(forgotPasswordRepo: getIt()),
  );
  // OTP VERIFY CODE
  getIt.registerLazySingleton<OtpVerifyCodeRepository>(
    () => OtpVerifyCodeRepository(apiService: getIt<ApiService>()),
  );

  getIt.registerFactory<OtpCubit>(
    () => OtpCubit(otpVerifyCodeRepository: getIt<OtpVerifyCodeRepository>()),
  );
  // New Password
  getIt.registerLazySingleton<NewPasswordRepo>(() => NewPasswordRepo(getIt()));
  getIt.registerFactory<NewPasswordCubit>(() => NewPasswordCubit(getIt()));
}
