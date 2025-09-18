import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_req_model.g.dart';

@JsonSerializable()
class ForgotPasswordReqModel {
  final String email;

  ForgotPasswordReqModel({required this.email});

  factory ForgotPasswordReqModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordReqModelToJson(this);
}


@JsonSerializable()
class ForgotPasswordSuccessResponse {
  final bool? success;
  final Map<String, dynamic>? data;

  ForgotPasswordSuccessResponse({this.success, this.data});

  factory ForgotPasswordSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordSuccessResponseToJson(this);
}