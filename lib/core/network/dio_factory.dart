import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:deliva_eat/core/auth/token_storage.dart';
import 'package:deliva_eat/core/auth/cart_key_storage.dart';
import 'package:deliva_eat/core/network/api_constant.dart';

class DioFactory {
  DioFactory._();
  static Dio? dio;
static Dio getDio() {
  Duration timeOut = const Duration(seconds: 60);
  if (dio == null) {
    dio = Dio();
    dio!
      ..options.baseUrl = ApiConstant.baseUrl
      ..options.connectTimeout = timeOut
      ..options.receiveTimeout = timeOut
      ..options.sendTimeout = timeOut;

    addDioInterCeptor();
    return dio!;
  } else {
    return dio!;
  }
}

  static void addDioInterCeptor() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await TokenStorage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer ' + token;
              options.headers.remove('x-cart-key');
            } else {
              options.headers.remove('Authorization');
              // provide per-device cart key for anonymous users
              final cartKey = await CartKeyStorage.getOrCreate();
              options.headers['x-cart-key'] = cartKey;
            }
            options.headers.putIfAbsent('Accept', () => 'application/json');
            options.headers.putIfAbsent('Content-Type', () => 'application/json');
          } catch (_) {
            // ignore token retrieval errors
          }
          handler.next(options);
        },
      ),
    );
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
