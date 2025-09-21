import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}