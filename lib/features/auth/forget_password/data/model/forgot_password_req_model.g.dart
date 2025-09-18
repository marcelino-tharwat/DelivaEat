// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_req_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordReqModel _$ForgotPasswordReqModelFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordReqModel(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordReqModelToJson(
  ForgotPasswordReqModel instance,
) => <String, dynamic>{'email': instance.email};

ForgotPasswordSuccessResponse _$ForgotPasswordSuccessResponseFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordSuccessResponse(
  success: json['success'] as bool?,
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ForgotPasswordSuccessResponseToJson(
  ForgotPasswordSuccessResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
