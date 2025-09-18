// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantModel _$MerchantModelFromJson(Map<String, dynamic> json) =>
    MerchantModel(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      id: json['id'] as String,
      userId: json['userId'] as String,
      businessType: json['businessType'] as String,
      restaurantName: json['restaurantName'] as String,
      ownerName: json['ownerName'] as String,
      ownerPhone: json['ownerPhone'] as String,
      description: json['description'] as String?,
      deliveryRadius: (json['deliveryRadius'] as num).toDouble(),
      address: json['address'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      avatarUrl: json['avatarUrl'] as String?,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$MerchantModelToJson(MerchantModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'id': instance.id,
      'userId': instance.userId,
      'businessType': instance.businessType,
      'restaurantName': instance.restaurantName,
      'ownerName': instance.ownerName,
      'ownerPhone': instance.ownerPhone,
      'description': instance.description,
      'deliveryRadius': instance.deliveryRadius,
      'address': instance.address,
      'location': instance.location?.toJson(),
      'avatarUrl': instance.avatarUrl,
      'active': instance.active,
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
