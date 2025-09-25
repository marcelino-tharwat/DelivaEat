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
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String preparationTime;
  final bool isAvailable;
  final bool isPopular;
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
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.preparationTime,
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
