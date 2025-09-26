import 'package:json_annotation/json_annotation.dart';
import 'restaurant_model.dart';

part 'food_model.g.dart';
@JsonSerializable()
class FoodModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String nameAr;
  final String? description;
  final String? descriptionAr;
  final String image;
  final double? price;
  final double? originalPrice;
  final double? rating;
  final int? reviewCount;
  final String? preparationTime;
  @JsonKey(defaultValue: true)
  final bool isAvailable;
  @JsonKey(defaultValue: false)
  final bool isPopular;
  @JsonKey(defaultValue: false)
  final bool isBestSelling;
  final RestaurantModel? restaurant;
  final List<String>? ingredients;
  final List<String>? allergens;
  final List<String>? tags;

  FoodModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.description,
    this.descriptionAr,
    required this.image,
    this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.preparationTime,
    required this.isAvailable,
    required this.isPopular,
    required this.isBestSelling,
    this.restaurant,
    this.ingredients,
    this.allergens,
    this.tags,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) =>
      _$FoodModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodModelToJson(this);
}
