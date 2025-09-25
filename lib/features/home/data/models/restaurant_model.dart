import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final String image;
  final String? coverImage;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final bool isOpen;
  final bool isActive;
  final bool isFavorite;
  final bool isTopRated;
  final String address;
  final String phone;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    required this.image,
    this.coverImage,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isOpen,
    required this.isActive,
    required this.isFavorite,
    required this.isTopRated,
    required this.address,
    required this.phone,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => 
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
