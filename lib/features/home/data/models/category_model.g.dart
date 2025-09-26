// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      icon: json['image'] as String? ?? '',
      color: json['color'] as String? ?? '',
      gradient:
          (json['gradient'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'image': instance.icon,
      'color': instance.color,
      'gradient': instance.gradient,
      'isActive': instance.isActive,
      'order': instance.order,
    };
