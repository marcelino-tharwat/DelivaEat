// import 'package:deliva_eat/core/network/api_error_handler.dart';
// import 'package:deliva_eat/features/auth/new_password/data/model/reset_password_request_body.dart';
// import 'package:deliva_eat/features/auth/otp/data/model/verify_code_request.dart';
// import 'package:dio/dio.dart';
// import 'package:either_dart/either.dart';
// import 'package:deliva_eat/core/network/api_service.dart';

// class NewPasswordRepo {
//   final ApiService _apiService;

//   NewPasswordRepo(this._apiService);

//   Future<Either<ApiErrorHandler, SuccessData>> resetPassword(
//     ResetPasswordRequestBody resetPasswordRequestBody,
//   ) async {
//     try {
//       final response = await _apiService.resetPassword(
//         resetPasswordRequestBody,
//       );

//       // -->> التحقق هنا <<--
//       if (response.data != null) {
//         // إذا لم تكن null، يمكننا تمريرها بأمان
//         return Right(response.data!);
//       } else {
//         // إذا كانت null، فهذا خطأ غير متوقع من السيرفر
//         return Left(ServerError("Response data is null"));
//       }

//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServerError.fromDioError(e));
//       } else {
//         return Left(ServerError(e.toString()));
//       }
//     }
//   }
// }import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/features/auth/new_password/data/model/reset_password_request_body.dart';
// تأكد من استيراد SuccessData. إذا كان في ملف reset_password_response، يمكنك استيراده.
import 'package:deliva_eat/features/auth/new_password/data/model/reset_password_response.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:deliva_eat/core/network/api_service.dart';

class NewPasswordRepo {
  final ApiService _apiService;

  NewPasswordRepo(this._apiService);

  Future<Either<ApiErrorHandler, SuccessData>> resetPassword(
    ResetPasswordRequestBody resetPasswordRequestBody,
  ) async {
    try {
      // الآن 'response' هو Map<String, dynamic> مباشرة من الـ JSON
      final response = await _apiService.resetPassword(
        resetPasswordRequestBody,
      );

      final bool success = response['success'] ?? false;
      final dynamic data = response['data'];

      if (success && data != null && data is Map<String, dynamic>) {
        // إذا نجحت العملية، قم بالتحليل إلى SuccessData
        return Right(SuccessData.fromJson(data));
      } else {
        // إذا فشلت، استخرج رسالة الخطأ أو أرجع خطأً عامًا
        final errorMessage = (data is Map && data.containsKey('error'))
            ? data['error'].toString()
            : 'Password reset failed. Please try again.';
        return Left(ServerError(errorMessage));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e));
      } else {
        return Left(ServerError(e.toString()));
      }
    }
  }
}
