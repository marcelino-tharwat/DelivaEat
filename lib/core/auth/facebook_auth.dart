import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';

class FacebookAuthService {
  FacebookAuthService._();

  static Future<Map<String, dynamic>> signInAndExchangeToken() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email'],
        loginBehavior: LoginBehavior.nativeWithFallback,
      );

      if (result.status != LoginStatus.success) {
        throw Exception(result.message ?? 'تم إلغاء تسجيل الدخول من فيسبوك');
      }

      final AccessToken? token = result.accessToken;
      if (token == null || token.tokenString.isEmpty) {
        throw Exception('لم يتم إرجاع accessToken من فيسبوك');
      }

      final api = ApiClient.create();
      final res = await api.postAuthFacebook(accessToken: token.tokenString);
      return res;
    } on DioException catch (e) {
      throw Exception(e.error?.toString() ?? 'فشل تسجيل الدخول بفيسبوك');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Facebook sign-in error: $e');
      }
      rethrow;
    }
  }
}
