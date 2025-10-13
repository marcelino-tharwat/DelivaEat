// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewsListData _$ReviewsListDataFromJson(Map<String, dynamic> json) =>
    ReviewsListData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$ReviewsListDataToJson(ReviewsListData instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };

ReviewsListResponse _$ReviewsListResponseFromJson(Map<String, dynamic> json) =>
    ReviewsListResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] == null
          ? null
          : ReviewsListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewsListResponseToJson(
  ReviewsListResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
