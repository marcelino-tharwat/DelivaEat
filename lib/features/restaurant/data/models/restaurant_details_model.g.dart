// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantDetailsData _$RestaurantDetailsDataFromJson(
  Map<String, dynamic> json,
) => RestaurantDetailsData(
  restaurant: RestaurantModel.fromJson(
    json['restaurant'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
  tabs: (json['tabs'] as List<dynamic>).map((e) => e as String).toList(),
  badges: (json['badges'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$RestaurantDetailsDataToJson(
  RestaurantDetailsData instance,
) => <String, dynamic>{
  'restaurant': instance.restaurant,
  'type': instance.type,
  'tabs': instance.tabs,
  'badges': instance.badges,
};

RestaurantDetailsResponse _$RestaurantDetailsResponseFromJson(
  Map<String, dynamic> json,
) => RestaurantDetailsResponse(
  success: json['success'] as bool? ?? false,
  data: json['data'] == null
      ? null
      : RestaurantDetailsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RestaurantDetailsResponseToJson(
  RestaurantDetailsResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
