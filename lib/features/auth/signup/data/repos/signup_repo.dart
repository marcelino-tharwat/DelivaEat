import 'dart:io';

import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/auth/login/data/models/auth_response.dart';
import 'package:deliva_eat/features/auth/signup/data/models/merchant_model.dart';
import 'package:deliva_eat/features/auth/signup/data/models/rider_model.dart';
import 'package:deliva_eat/features/auth/signup/data/models/signup_req_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class SignupRepo {
    final Dio dio; // NEW: Add dio instance here

  final ApiService apiService;
  SignupRepo(this.dio, {required this.apiService});

  Future<Either<ApiErrorHandler, AuthResponse>> register({
    required SignupReqModel signupReqModel,
    context,
  }) async {
    try {
      final response = await apiService.userRegister(signupReqModel);
      return Right(response);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e));
      } else {
        return Left(ServerError(e.toString()));
      }
    }
  }
    Future<Either<ApiErrorHandler, AuthResponse>> riderRegister({
    required RiderModel riderModel,
    context,
  }) async {
    try {
      final response = await apiService.riderRegister(riderModel);
      return Right(response);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e));
      } else {
        return Left(ServerError(e.toString()));
      }
    }
  }
    Future<Either<ApiErrorHandler, String>> uploadRiderImage({
    required File imageFile,
    required  context,
  }) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        // The field name 'image' matches the backend ('upload.single('image')')
        "image": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      // Use the injected Dio instance which has the correct timeout settings
      final response = await dio.post(ApiConstant.baseUrl+
        ApiConstant.uploadImageUrl,
        data: formData,
      );

      // The backend returns { success: true, data: { url: '...' } }
      final imageUrl = response.data['data']['url'] as String;
      return Right(imageUrl);
      
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e, ));
      } else {
        return Left(ServerError(e.toString()));
      }
    }
  }
    Future<Either<ApiErrorHandler, AuthResponse>> merchantRegister({
    required MerchantModel merchantModel,
    context,
  }) async {
    try {
      final response = await apiService.merchantRegister(merchantModel);
      return Right(response);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e));
      } else {
        return Left(ServerError(e.toString()));
      }
    }
  }
}


