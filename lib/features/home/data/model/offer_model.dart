import 'package:flutter/material.dart';

class Offer {
  final String title;
  final String subtitle;
  final Color color;
  final String icon;
  final String image;
  final String discount;

  Offer({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.image,
    required this.discount,
  });
}