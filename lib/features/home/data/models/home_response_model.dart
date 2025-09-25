import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';
import 'offer_model.dart';
import 'restaurant_model.dart';
import 'food_model.dart';

part 'home_response_model.g.dart';

@JsonSerializable()
class HomeResponseModel {
  final bool? success;
  final HomeDataModel data;

  HomeResponseModel({
    required this.success,
    required this.data,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) => 
      _$HomeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseModelToJson(this);
}

@JsonSerializable()
class HomeDataModel {
  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final List<RestaurantModel> favoriteRestaurants;
  final List<RestaurantModel> topRatedRestaurants;
  final List<FoodModel> bestSellingFoods;

  HomeDataModel({
    required this.categories,
    required this.offers,
    required this.favoriteRestaurants,
    required this.topRatedRestaurants,
    required this.bestSellingFoods,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => 
      _$HomeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class HomeResultResponseModel<T> {
  final bool? success;
  final T? data;

  HomeResultResponseModel({
    required this.success,
    required this.data,
  });

  factory HomeResultResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      HomeResultResponseModel<T>(
        success: json['success'] as bool?,
        data: json['data'] == null ? null : fromJsonT(json['data']),
      );

  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) =>
      <String, dynamic>{
        'success': success,
        'data': data == null ? null : toJsonT(data as T),
      };
}
