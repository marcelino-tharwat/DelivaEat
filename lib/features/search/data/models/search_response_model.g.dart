// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponseModel _$SearchResponseModelFromJson(Map<String, dynamic> json) =>
    SearchResponseModel(
      success: json['success'] as bool,
      data: SearchDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchResponseModelToJson(
  SearchResponseModel instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

SearchDataModel _$SearchDataModelFromJson(Map<String, dynamic> json) =>
    SearchDataModel(
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      foods: (json['foods'] as List<dynamic>)
          .map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$SearchDataModelToJson(SearchDataModel instance) =>
    <String, dynamic>{
      'restaurants': instance.restaurants,
      'foods': instance.foods,
      'total': instance.total,
      'page': instance.page,
      'totalPages': instance.totalPages,
    };

SearchSuggestionModel _$SearchSuggestionModelFromJson(
  Map<String, dynamic> json,
) => SearchSuggestionModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  image: json['image'] as String,
  restaurant: json['restaurant'] as String?,
);

Map<String, dynamic> _$SearchSuggestionModelToJson(
  SearchSuggestionModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'image': instance.image,
  'restaurant': instance.restaurant,
};

PopularSearchModel _$PopularSearchModelFromJson(Map<String, dynamic> json) =>
    PopularSearchModel(
      term: json['term'] as String,
      count: (json['count'] as num).toDouble(),
    );

Map<String, dynamic> _$PopularSearchModelToJson(PopularSearchModel instance) =>
    <String, dynamic>{'term': instance.term, 'count': instance.count};

SearchSuggestionsResponseModel _$SearchSuggestionsResponseModelFromJson(
  Map<String, dynamic> json,
) => SearchSuggestionsResponseModel(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => SearchSuggestionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SearchSuggestionsResponseModelToJson(
  SearchSuggestionsResponseModel instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

PopularSearchesResponseModel _$PopularSearchesResponseModelFromJson(
  Map<String, dynamic> json,
) => PopularSearchesResponseModel(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => PopularSearchModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PopularSearchesResponseModelToJson(
  PopularSearchesResponseModel instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
