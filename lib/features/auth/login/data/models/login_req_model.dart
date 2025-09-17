import 'package:json_annotation/json_annotation.dart';

part 'login_req_model.g.dart';

@JsonSerializable()
class LoginReqModel {
  String email;
  String password;

  LoginReqModel(this.email, this.password);

  factory LoginReqModel.fromJson(Map<String, dynamic> json) =>
      _$LoginReqModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginReqModelToJson(this);
}
