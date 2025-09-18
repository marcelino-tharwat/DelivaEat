import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/auth/forget_password/data/model/forgot_password_req_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class ForgotPasswordRepo {
  final ApiService _apiService;

  ForgotPasswordRepo(this._apiService);

  Future<Either<ApiErrorHandler, ForgotPasswordSuccessResponse>>
  requestPasswordReset({
    required String email,
    required BuildContext context,
  }) async {
    try {
      final response = await _apiService.requestPasswordReset(ForgotPasswordReqModel(email: email));
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
