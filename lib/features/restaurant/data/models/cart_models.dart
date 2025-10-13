import 'package:json_annotation/json_annotation.dart';

part 'cart_models.g.dart';

@JsonSerializable()
class AddCartItemRequest {
  final String foodId;
  @JsonKey(defaultValue: 1)
  final int quantity;
  @JsonKey(defaultValue: [])
  final List<CartOption> options;

  AddCartItemRequest({
    required this.foodId,
    this.quantity = 1,
    this.options = const [],
  });

  factory AddCartItemRequest.fromJson(Map<String, dynamic> json) => _$AddCartItemRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddCartItemRequestToJson(this);
}

@JsonSerializable()
class CartOption {
  final String code;
  @JsonKey(defaultValue: 0)
  final int price;

  CartOption({required this.code, required this.price});

  factory CartOption.fromJson(Map<String, dynamic> json) => _$CartOptionFromJson(json);
  Map<String, dynamic> toJson() => _$CartOptionToJson(this);
}

@JsonSerializable()
class CartItemModel {
  @JsonKey(name: '_id')
  final String? id;
  final String foodId;
  @JsonKey(defaultValue: 1)
  final int quantity;
  @JsonKey(defaultValue: [])
  final List<CartOption> options;
  final String? addedAt;

  CartItemModel({
    this.id,
    required this.foodId,
    required this.quantity,
    required this.options,
    this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}
