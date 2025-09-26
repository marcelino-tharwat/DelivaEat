import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String nameAr;
  @JsonKey(name: 'image', defaultValue: '')
  final String icon;
  @JsonKey(defaultValue: '')
  final String color;
  @JsonKey(defaultValue: const [])
  final List<String> gradient;
  @JsonKey(defaultValue: true)
  final bool? isActive;
  final int? order;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.isActive,
    required this.order,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => 
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
