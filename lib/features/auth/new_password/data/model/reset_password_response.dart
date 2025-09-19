import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ResetPasswordResponse<T> {
  final bool success;
  final T data;
  
  ResetPasswordResponse({required this.success, required this.data});

  factory ResetPasswordResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ResetPasswordResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ResetPasswordResponseToJson(this, toJsonT);
}


// نموذج للرسالة فقط في حالة النجاح
@JsonSerializable()
class SuccessData {
  final String message;

  SuccessData({required this.message});

  factory SuccessData.fromJson(Map<String, dynamic> json) =>
      _$SuccessDataFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessDataToJson(this);
}