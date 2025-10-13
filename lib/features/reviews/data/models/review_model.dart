import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? foodId;
  final String? restaurantId;
  @JsonKey(defaultValue: '')
  final String userName;
  @JsonKey(defaultValue: 0)
  final int rating;
  @JsonKey(defaultValue: '')
  final String comment;
  final String? createdAt;

  ReviewModel({
    this.id,
    this.foodId,
    this.restaurantId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
