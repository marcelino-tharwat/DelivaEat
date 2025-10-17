// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponse _$CartResponseFromJson(Map<String, dynamic> json) => CartResponse(
  success: json['success'] as bool? ?? false,
  data: json['data'] == null
      ? null
      : CartData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CartResponseToJson(CartResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

CartData _$CartDataFromJson(Map<String, dynamic> json) => CartData(
  ownerKey: json['ownerKey'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
  'ownerKey': instance.ownerKey,
  'items': instance.items,
};
