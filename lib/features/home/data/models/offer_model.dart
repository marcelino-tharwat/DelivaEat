import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@JsonSerializable()
class OfferModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String titleAr;
  final String subtitle;
  final String subtitleAr;
  final String color;
  final String icon;
  final String image;
  final String discount;
  final String discountType;
  @JsonKey(defaultValue: true)
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final int order;

  OfferModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.subtitle,
    required this.subtitleAr,
    required this.color,
    required this.icon,
    required this.image,
    required this.discount,
    required this.discountType,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.order,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => 
      _$OfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferModelToJson(this);
}
