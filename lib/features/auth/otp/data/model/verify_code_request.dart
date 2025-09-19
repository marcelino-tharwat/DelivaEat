import 'package:json_annotation/json_annotation.dart';

part 'verify_code_request.g.dart';

@JsonSerializable()
class VerifyCodeRequest {
  final String email;
  @JsonKey(name: 'code') // اسم الحقل في الـ API
  final String code;

  VerifyCodeRequest({required this.email, required this.code});

  factory VerifyCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}

// import 'package:json_annotation/json_annotation.dart';

// part 'api_response.g.dart';

// موديل للتعامل مع الأخطاء القادمة من الباك اند
@JsonSerializable()
class ApiError {
  final String code;
  final String message;

  ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

// موديل للبيانات في حالة النجاح
@JsonSerializable()
class SuccessData {
  final bool valid;

  SuccessData({required this.valid});

  factory SuccessData.fromJson(Map<String, dynamic> json) =>
      _$SuccessDataFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessDataToJson(this);
}


// الموديل العام للـ Response
// استخدمنا generic type T لتمرير نوع الـ data
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final T? data;
  final ApiError? error;

  ApiResponse({required this.success, this.data, this.error});

  factory ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}