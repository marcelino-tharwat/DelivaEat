// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_req_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupReqModel _$SignupReqModelFromJson(Map<String, dynamic> json) =>
    SignupReqModel(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$SignupReqModelToJson(SignupReqModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'role': instance.role,
    };
