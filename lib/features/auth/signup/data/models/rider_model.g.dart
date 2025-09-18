// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RiderModel _$RiderModelFromJson(Map<String, dynamic> json) => RiderModel(
  json['active'] as bool?,
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  phone: json['phone'] as String?,
  vehicleType: json['vehicleType'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  idCardUrl: json['idCardUrl'] as String?,
  licenseUrl: json['licenseUrl'] as String?,
  vehicleUrlFront: json['vehicleUrlFront'] as String?,
  vehicleUrlSide: json['vehicleUrlSide'] as String?,
  licensePlateUrl: json['licensePlateUrl'] as String?,
);

Map<String, dynamic> _$RiderModelToJson(RiderModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'vehicleType': instance.vehicleType,
      'avatarUrl': instance.avatarUrl,
      'idCardUrl': instance.idCardUrl,
      'licenseUrl': instance.licenseUrl,
      'vehicleUrlFront': instance.vehicleUrlFront,
      'vehicleUrlSide': instance.vehicleUrlSide,
      'licensePlateUrl': instance.licensePlateUrl,
      'active': instance.active,
    };
