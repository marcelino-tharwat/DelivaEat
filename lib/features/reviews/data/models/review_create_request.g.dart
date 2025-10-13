// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewCreateRequest _$ReviewCreateRequestFromJson(Map<String, dynamic> json) =>
    ReviewCreateRequest(
      foodId: json['foodId'] as String?,
      restaurantId: json['restaurantId'] as String?,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$ReviewCreateRequestToJson(
  ReviewCreateRequest instance,
) => <String, dynamic>{
  'foodId': instance.foodId,
  'restaurantId': instance.restaurantId,
  'rating': instance.rating,
  'comment': instance.comment,
};
