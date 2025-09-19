import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();
  static Dio? dio;
static Dio getDio() {
  Duration timeOut = const Duration(seconds: 60);
  if (dio == null) {
    dio = Dio();
    dio!
      ..options.connectTimeout = timeOut
      ..options.receiveTimeout = timeOut
      ..options.sendTimeout = timeOut; // <--- أضف هذا السطر المهم

    addDioInterCeptor();
    return dio!;
  } else {
    return dio!;
  }
}

static void addDioInterCeptor() {
  dio?.interceptors.add(
    PrettyDioLogger(requestBody: true, responseHeader: true),
  );
}
}

class MyHttpOverrides extends HttpOverrides {
  @override

  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
