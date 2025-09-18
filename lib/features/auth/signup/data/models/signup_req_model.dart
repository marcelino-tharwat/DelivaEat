import 'package:json_annotation/json_annotation.dart';

part 'signup_req_model.g.dart';

@JsonSerializable()
class SignupReqModel {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? role; // user | rider | merchant

  SignupReqModel({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.role,
  });

  /// fromJson
  factory SignupReqModel.fromJson(Map<String, dynamic> json) =>
      _$SignupReqModelFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$SignupReqModelToJson(this);
}
