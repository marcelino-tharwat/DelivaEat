import 'package:json_annotation/json_annotation.dart';

part 'merchant_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MerchantModel {
  // NEW: Add basic user fields required by the backend
  final String name;
  final String email;
  final String password;
  final String phone;

  // Existing merchant fields
  final String id;
  final String userId;
  final String businessType;
  final String restaurantName;
  final String ownerName;
  final String ownerPhone;
  final String? description;
  final double deliveryRadius;
  final String? address;
  final LocationModel? location;
  final String? avatarUrl; // This needs to be optional or a valid string
  final bool active;

  MerchantModel({
    // Add new fields to constructor
    required this.name,
    required this.email,
    required this.password,
    required this.phone,

    // Existing fields
    required this.id,
    required this.userId,
    required this.businessType,
    required this.restaurantName,
    required this.ownerName,
    required this.ownerPhone,
    this.description,
    required this.deliveryRadius,
    this.address,
    this.location,
    this.avatarUrl,
    required this.active,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantModelToJson(this);
}

@JsonSerializable()
class LocationModel {
  final double lat;
  final double lng;

  LocationModel({
    required this.lat,
    required this.lng,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
