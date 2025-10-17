import 'package:json_annotation/json_annotation.dart';
import 'package:deliva_eat/features/restaurant/data/models/cart_models.dart';

part 'cart_response.g.dart';

@JsonSerializable()
class CartResponse {
  @JsonKey(defaultValue: false)
  final bool success;
  final CartData? data;

  CartResponse({required this.success, this.data});

  factory CartResponse.fromJson(Map<String, dynamic> json) => _$CartResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CartResponseToJson(this);
}

@JsonSerializable()
class CartData {
  final String ownerKey;
  @JsonKey(defaultValue: [])
  final List<CartItemModel> items;

  CartData({required this.ownerKey, required this.items});

  factory CartData.fromJson(Map<String, dynamic> json) => _$CartDataFromJson(json);
  Map<String, dynamic> toJson() => _$CartDataToJson(this);
}
