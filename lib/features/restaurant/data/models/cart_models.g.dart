// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCartItemRequest _$AddCartItemRequestFromJson(Map<String, dynamic> json) =>
    AddCartItemRequest(
      foodId: json['foodId'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => CartOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AddCartItemRequestToJson(AddCartItemRequest instance) =>
    <String, dynamic>{
      'foodId': instance.foodId,
      'quantity': instance.quantity,
      'options': instance.options,
    };

CartFoodBrief _$CartFoodBriefFromJson(Map<String, dynamic> json) =>
    CartFoodBrief(
      id: json['id'] as String?,
      name: json['name'] as String?,
      nameAr: json['nameAr'] as String?,
      image: json['image'] as String?,
      price: json['price'] as num?,
    );

Map<String, dynamic> _$CartFoodBriefToJson(CartFoodBrief instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'image': instance.image,
      'price': instance.price,
    };

CartOption _$CartOptionFromJson(Map<String, dynamic> json) => CartOption(
  code: json['code'] as String,
  price: (json['price'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CartOptionToJson(CartOption instance) =>
    <String, dynamic>{'code': instance.code, 'price': instance.price};

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['_id'] as String?,
      foodId: json['foodId'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => CartOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      addedAt: json['addedAt'] as String?,
      food: json['food'] == null
          ? null
          : CartFoodBrief.fromJson(json['food'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'foodId': instance.foodId,
      'quantity': instance.quantity,
      'options': instance.options,
      'addedAt': instance.addedAt,
      'food': instance.food,
    };
