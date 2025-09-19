// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordResponse<T> _$ResetPasswordResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ResetPasswordResponse<T>(
  success: json['success'] as bool,
  data: fromJsonT(json['data']),
);

Map<String, dynamic> _$ResetPasswordResponseToJson<T>(
  ResetPasswordResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'data': toJsonT(instance.data),
};

SuccessData _$SuccessDataFromJson(Map<String, dynamic> json) =>
    SuccessData(message: json['message'] as String);

Map<String, dynamic> _$SuccessDataToJson(SuccessData instance) =>
    <String, dynamic>{'message': instance.message};
