import 'package:deliva_eat/deliva_eat.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/core/network/dio_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const DelivaEat());
}
