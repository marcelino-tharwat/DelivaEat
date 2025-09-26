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
  final double? rating;
  final int? reviewCount;
  final String? deliveryTime;
  final double? deliveryFee;
  final double? minimumOrder;

  @JsonKey(defaultValue: true)
  final bool? isOpen;
  @JsonKey(defaultValue: true)
  final bool? isActive;
  @JsonKey(defaultValue: false)
  final bool? isFavorite;
  @JsonKey(defaultValue: false)
  final bool? isTopRated;
  final String? address;
  final String? phone;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    required this.image,
    this.coverImage,
    this.rating,
    this.reviewCount,
    this.deliveryTime,
    this.deliveryFee,
    this.minimumOrder,
    this.isOpen,
    this.isActive,
    this.isFavorite,
    this.isTopRated,
    this.address,
    this.phone,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
