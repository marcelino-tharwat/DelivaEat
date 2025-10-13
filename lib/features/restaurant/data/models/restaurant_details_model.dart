import 'package:json_annotation/json_annotation.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';

part 'restaurant_details_model.g.dart';

@JsonSerializable()
class RestaurantDetailsData {
  final RestaurantModel restaurant;
  final String type;
  final List<String> tabs;
  final List<String> badges;

  RestaurantDetailsData({
    required this.restaurant,
    required this.type,
    required this.tabs,
    required this.badges,
  });

  factory RestaurantDetailsData.fromJson(Map<String, dynamic> json) => _$RestaurantDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantDetailsDataToJson(this);
}

@JsonSerializable()
class RestaurantDetailsResponse {
  @JsonKey(defaultValue: false)
  final bool success;
  final RestaurantDetailsData? data;

  RestaurantDetailsResponse({
    required this.success,
    this.data,
  });

  factory RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) => _$RestaurantDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantDetailsResponseToJson(this);
}
