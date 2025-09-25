import 'package:json_annotation/json_annotation.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';

part 'search_response_model.g.dart';

@JsonSerializable()
class SearchResponseModel {
  final bool success;
  final SearchDataModel data;

  SearchResponseModel({
    required this.success,
    required this.data,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) => 
      _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);
}

@JsonSerializable()
class SearchDataModel {
  final List<RestaurantModel> restaurants;
  final List<FoodModel> foods;
  final int total;
  final int page;
  final int totalPages;

  SearchDataModel({
    required this.restaurants,
    required this.foods,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) => 
      _$SearchDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataModelToJson(this);
}

@JsonSerializable()
class SearchSuggestionModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String type;
  final String image;
  final String? restaurant;

  SearchSuggestionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    this.restaurant,
  });

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) => 
      _$SearchSuggestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSuggestionModelToJson(this);
}

@JsonSerializable()
class PopularSearchModel {
  final String term;
  final double count;

  PopularSearchModel({
    required this.term,
    required this.count,
  });

  factory PopularSearchModel.fromJson(Map<String, dynamic> json) => 
      _$PopularSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$PopularSearchModelToJson(this);
}

@JsonSerializable()
class SearchSuggestionsResponseModel {
  final bool success;
  final List<SearchSuggestionModel> data;

  SearchSuggestionsResponseModel({
    required this.success,
    required this.data,
  });

  factory SearchSuggestionsResponseModel.fromJson(Map<String, dynamic> json) => 
      _$SearchSuggestionsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSuggestionsResponseModelToJson(this);
}

@JsonSerializable()
class PopularSearchesResponseModel {
  final bool success;
  final List<PopularSearchModel> data;

  PopularSearchesResponseModel({
    required this.success,
    required this.data,
  });

  factory PopularSearchesResponseModel.fromJson(Map<String, dynamic> json) => 
      _$PopularSearchesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PopularSearchesResponseModelToJson(this);
}
