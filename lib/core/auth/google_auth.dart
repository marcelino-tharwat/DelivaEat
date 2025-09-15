import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        const String.fromEnvironment(
          'GOOGLE_CLIENT_ID',
          // Firebase Web client ID for project pass-jordan
          defaultValue:
              '377203092068-6kmmskbah407n5u7c89dop86siofnvr8.apps.googleusercontent.com',
        ),
    scopes: <String>['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInAndExchangeToken() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('تم إلغاء تسجيل الدخول من جوجل');
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        throw Exception('لم يتم إرجاع idToken من جوجل');
      }

      final api = ApiClient.create();
      final res = await api.postAuthGoogle(idToken: idToken);
      return res;
    } on DioException catch (e) {
      throw Exception(e.error?.toString() ?? 'فشل تسجيل الدخول بجوجل');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Google sign-in error: $e');
      }
      rethrow;
    }
  }
}
