// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodModel _$FoodModelFromJson(Map<String, dynamic> json) => FoodModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  nameAr: json['nameAr'] as String,
  description: json['description'] as String?,
  descriptionAr: json['descriptionAr'] as String?,
  image: json['image'] as String,
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  preparationTime: json['preparationTime'] as String,
  isAvailable: (json['isAvailable'] as bool?) ?? true,
  isPopular: (json['isPopular'] as bool?) ?? false,
  isBestSelling: (json['isBestSelling'] as bool?) ?? false,
  restaurant: json['restaurant'] == null
      ? null
      : RestaurantModel.fromJson(json['restaurant'] as Map<String, dynamic>),
  ingredients: (json['ingredients'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  allergens: (json['allergens'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$FoodModelToJson(FoodModel instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'nameAr': instance.nameAr,
  'description': instance.description,
  'descriptionAr': instance.descriptionAr,
  'image': instance.image,
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'preparationTime': instance.preparationTime,
  'isAvailable': instance.isAvailable,
  'isPopular': instance.isPopular,
  'isBestSelling': instance.isBestSelling,
  'restaurant': instance.restaurant,
  'ingredients': instance.ingredients,
  'allergens': instance.allergens,
  'tags': instance.tags,
};
