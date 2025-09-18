import 'package:json_annotation/json_annotation.dart';

part 'rider_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RiderModel {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String vehicleType;

  // صور وملفات
  final String? avatarUrl;
  final String? idCardUrl;
  final String? licenseUrl;
  final String? vehicleUrlFront;
  final String? vehicleUrlSide;
  final String? licensePlateUrl;
  final bool? active;
  RiderModel(this.active, {
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    required this.vehicleType,

    this.avatarUrl,
    this.idCardUrl,
    this.licenseUrl,
    this.vehicleUrlFront,
    this.vehicleUrlSide,
    this.licensePlateUrl,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) =>
      _$RiderModelFromJson(json);

  Map<String, dynamic> toJson() => _$RiderModelToJson(this);
}
