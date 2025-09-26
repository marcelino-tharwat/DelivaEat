// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) => OfferModel(
  id: json['_id'] as String,
  title: json['title'] as String,
  titleAr: json['titleAr'] as String,
  subtitle: json['subtitle'] as String,
  subtitleAr: json['subtitleAr'] as String,
  color: json['color'] as String,
  icon: json['icon'] as String,
  image: json['image'] as String,
  discount: json['discount'] as String,
  discountType: json['discountType'] as String,
  isActive: json['isActive'] as bool? ?? true,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  order: (json['order'] as num?)?.toInt(),
);

Map<String, dynamic> _$OfferModelToJson(OfferModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'titleAr': instance.titleAr,
      'subtitle': instance.subtitle,
      'subtitleAr': instance.subtitleAr,
      'color': instance.color,
      'icon': instance.icon,
      'image': instance.image,
      'discount': instance.discount,
      'discountType': instance.discountType,
      'isActive': instance.isActive,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'order': instance.order,
    };
