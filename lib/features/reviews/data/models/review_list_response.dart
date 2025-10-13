import 'package:json_annotation/json_annotation.dart';
import 'review_model.dart';

part 'review_list_response.g.dart';

@JsonSerializable()
class ReviewsListData {
  @JsonKey(defaultValue: [])
  final List<ReviewModel> items;
  @JsonKey(defaultValue: 0)
  final int total;
  @JsonKey(defaultValue: 1)
  final int page;
  @JsonKey(defaultValue: 20)
  final int limit;

  ReviewsListData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory ReviewsListData.fromJson(Map<String, dynamic> json) => _$ReviewsListDataFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewsListDataToJson(this);
}

@JsonSerializable()
class ReviewsListResponse {
  @JsonKey(defaultValue: false)
  final bool success;
  final ReviewsListData? data;

  ReviewsListResponse({
    required this.success,
    this.data,
  });

  factory ReviewsListResponse.fromJson(Map<String, dynamic> json) => _$ReviewsListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewsListResponseToJson(this);
}
