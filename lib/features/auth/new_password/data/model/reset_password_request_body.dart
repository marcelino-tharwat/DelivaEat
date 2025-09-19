import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_body.g.dart';

@JsonSerializable()
class ResetPasswordRequestBody {
  final String email;
  final String code; // الباك اند يتوقع 'code', وليس 'token'
  final String newPassword;

  ResetPasswordRequestBody({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  factory ResetPasswordRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestBodyToJson(this);
}