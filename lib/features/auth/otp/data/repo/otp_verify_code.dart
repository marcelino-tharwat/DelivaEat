// import 'package:deliva_eat/core/network/api_error_handler.dart';
// import 'package:deliva_eat/core/network/api_service.dart';
// import 'package:deliva_eat/features/auth/forget_password/data/model/forgot_password_req_model.dart';
// import 'package:deliva_eat/features/auth/otp/data/model/verify_code_request.dart';
// import 'package:dio/dio.dart';
// import 'package:either_dart/either.dart';
// import 'package:flutter/material.dart';

// class OtpVerifyCodeRepository {
//   final ApiService apiService;
//   OtpVerifyCodeRepository({required this.apiService});

//   Future<Either<ApiErrorHandler, ApiResponse<SuccessData>>> verifyCode({
//     required String email,
//     required String code,
//     required BuildContext
//     context,
//   }) async {
//     try {
//       final request = VerifyCodeRequest(email: email, code: code);
//       final response = await apiService.verifyResetCode(request);

//       if (!response.success || response.data?.valid != true) {
//         return Left(
//           ServerError(response.error?.message ?? 'Invalid or expired code.'),
//         );
//       }
//       return Right(response);
//     } catch (e) {
//       if (e is DioException) {
//         // --- >> بداية الحل << ---

//         // 1. تحقق مما إذا كان الخطأ هو "badResponse" ويحتوي على بيانات
//         if (e.type == DioExceptionType.badResponse &&
//             e.response?.data != null) {
//           // 2. اقرأ جسم الاستجابة (JSON)
//           final responseData = e.response!.data;
//           String errorMessage = 'An unknown error occurred.'; // رسالة افتراضية

//           // 3. حاول استخراج رسالة الخطأ المخصصة من الـ JSON
//           if (responseData is Map<String, dynamic>) {
//             // هذا يطابق البنية التي لديك: {"error": {"message": "..."}}
//             if (responseData['error'] is Map<String, dynamic>) {
//               final errorMap = responseData['error'] as Map<String, dynamic>;
//               errorMessage = errorMap['message'] ?? 'Invalid code.';
//             }
//             // هذا للتعامل مع بنية أخرى محتملة: {"message": "..."}
//             else if (responseData['message'] != null) {
//               errorMessage = responseData['message'];
//             }
//           }

//           // 4. أرجع الخطأ مع الرسالة المخصصة التي استخرجتها
//           return Left(ServerError(errorMessage));
//         } else {
//           // 5. إذا كان الخطأ من نوع آخر (مثل timeout)، استخدم المعالج القديم
//           return Left(ServerError.fromDioError(e));
//         }
//         // --- >> نهاية الحل << ---
//       } else {
//         // للأخطاء الأخرى غير المتوقعة
//         return Left(ServerError('An unknown error occurred.'));
//       }
//     }
//   }

//   Future<Either<ApiErrorHandler, ForgotPasswordSuccessResponse>>
//   requestPasswordReset({
//     required String email,
//     required BuildContext context,
//   }) async {
//     try {
//       final response = await apiService.requestPasswordReset(
//         ForgotPasswordReqModel(email: email),
//       );
//       return Right(response);
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServerError.fromDioError(e));
//       } else {
//         return Left(ServerError(e.toString()));
//       }
//     }
//   }
// }

import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/auth/forget_password/data/model/forgot_password_req_model.dart';
import 'package:deliva_eat/features/auth/otp/data/model/verify_code_request.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class OtpVerifyCodeRepository {
  final ApiService apiService;

  OtpVerifyCodeRepository({required this.apiService});

  Future<Either<ApiErrorHandler, ApiResponse<SuccessData>>> verifyCode({
    required String email,
    required String code,
    required BuildContext context,
  }) async {
    try {
      final request = VerifyCodeRequest(email: email, code: code);
      final response = await apiService.verifyResetCode(request);

      if (!response.success || response.data?.valid != true) {
        return Left(
          ServerError(
            response.error?.message ??
                AppLocalizations.of(context)!.invalid_or_expired_code,
          ),
        );
      }
      return Right(response);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.badResponse &&
            e.response?.data != null) {
          final responseData = e.response!.data;
          String errorMessage = AppLocalizations.of(
            context,
          )!.error_unknown; // default msg

          if (responseData is Map<String, dynamic>) {
            if (responseData['error'] is Map<String, dynamic>) {
              final errorMap = responseData['error'] as Map<String, dynamic>;
              errorMessage =
                  errorMap['message'] ??
                  AppLocalizations.of(context)!.invalid_code;
            } else if (responseData['message'] != null) {
              errorMessage = responseData['message'];
            }
          }

          return Left(ServerError(errorMessage));
        } else {
          return Left(ServerError.fromDioError(e));
        }
      } else {
        return Left(ServerError(AppLocalizations.of(context)!.error_unknown));
      }
    }
  }

  Future<Either<ApiErrorHandler, ForgotPasswordSuccessResponse>>
  requestPasswordReset({
    required String email,
    required BuildContext context,
  }) async {
    try {
      final response = await apiService.requestPasswordReset(
        ForgotPasswordReqModel(email: email),
      );
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
