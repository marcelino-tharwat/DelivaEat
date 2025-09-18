import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/auth/login/data/models/login_req_model.dart';
import 'package:deliva_eat/features/auth/login/data/models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class LoginRepo {
  final ApiService apiService;
  LoginRepo({required this.apiService});
  Future<Either<ApiErrorHandler, AuthResponse>> login({
    required LoginReqModel loginReqModel,
    context,
  }) async {
    try {
      var response = await apiService.login(loginReqModel);
      return Right(response);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e, context));
      } else {
        return Left(ServerError(e.toString()));
      }
    }
  }
}
