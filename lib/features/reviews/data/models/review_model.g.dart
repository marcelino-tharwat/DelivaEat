// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: json['_id'] as String?,
  foodId: json['foodId'] as String?,
  restaurantId: json['restaurantId'] as String?,
  userName: json['userName'] as String? ?? '',
  rating: (json['rating'] as num?)?.toInt() ?? 0,
  comment: json['comment'] as String? ?? '',
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'foodId': instance.foodId,
      'restaurantId': instance.restaurantId,
      'userName': instance.userName,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
    };
