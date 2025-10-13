import 'package:json_annotation/json_annotation.dart';

part 'review_create_request.g.dart';

@JsonSerializable()
class ReviewCreateRequest {
  final String? foodId;
  final String? restaurantId;
  final int rating;
  final String comment;

  ReviewCreateRequest({
    this.foodId,
    this.restaurantId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => _$ReviewCreateRequestToJson(this);
  factory ReviewCreateRequest.fromJson(Map<String, dynamic> json) => _$ReviewCreateRequestFromJson(json);
}
