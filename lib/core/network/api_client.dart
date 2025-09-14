import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  static ApiClient create({String? baseUrl}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://192.168.1.3:5000'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onError: (err, handler) {
        // Surface backend unified error with details when available
        final data = err.response?.data;
        if (data is Map && data['success'] == false && data['error'] is Map) {
          final baseMsg = data['error']['message']?.toString() ?? 'Request failed';
          final details = data['details'];
          String pretty = baseMsg;
          if (details is List) {
            final lines = <String>[];
            for (final d in details) {
              if (d is Map) {
                final field = (d['path'] ?? d['param'] ?? '').toString();
                final msg = (d['msg'] ?? d['message'] ?? '').toString();
                if (field.isNotEmpty && msg.isNotEmpty) {
                  lines.add('- $field: $msg');
                } else if (msg.isNotEmpty) {
                  lines.add('- $msg');
                }
              }
            }
            if (lines.isNotEmpty) {
              pretty = '$baseMsg\n' + lines.join('\n');
            }
          }
          err = DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: err.type,
            error: pretty,
          );
        }
        handler.next(err);
      },
    ));

    return ApiClient._(dio);
  }

  Future<Map<String, dynamic>> postAuthRegister({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? role, // User | Rider | Merchant
  }) async {
    final res = await _dio.post(
      '/api/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (role != null && role.isNotEmpty) 'role': role,
      },
    );
    if (res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    throw Exception('Unexpected response');
  }

  Future<Map<String, dynamic>> postAuthLogin({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    if (res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    throw Exception('Unexpected response');
  }

  Future<String> uploadImage({required String filePath}) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
    });
    final res = await _dio.post('/api/upload/image', data: formData);
    if (res.data is Map<String, dynamic>) {
      final data = res.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return (data['data']?['url'] ?? data['url']) as String;
      }
      throw Exception((data['error']?['message'] ?? 'Image upload failed').toString());
    }
    throw Exception('Unexpected upload response');
  }

  Future<Map<String, dynamic>> postRiderRegister({
    required String name,
    required String email,
    required String password,
    String? phone,
    required String vehicleType, // UI label; backend normalizes
    String? avatarUrl,
    String? idCardUrl,
    String? licenseUrl,
    String? vehicleUrlFront,
    String? vehicleUrlSide,
    String? licensePlateUrl,
  }) async {
    final res = await _dio.post(
      '/api/rider/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        'role': 'Rider',
        'vehicleType': vehicleType,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (idCardUrl != null) 'idCardUrl': idCardUrl,
        if (licenseUrl != null) 'licenseUrl': licenseUrl,
        if (vehicleUrlFront != null) 'vehicleUrlFront': vehicleUrlFront,
        if (vehicleUrlSide != null) 'vehicleUrlSide': vehicleUrlSide,
        if (licensePlateUrl != null) 'licensePlateUrl': licensePlateUrl,
      },
    );
    if (res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    throw Exception('Unexpected response');
  }

  Future<Map<String, dynamic>> postMerchantRegister({
    required String name,
    required String email,
    required String password,
    String? phone,
    required String businessType, // UI label; backend normalizes
    required String restaurantName,
    required String ownerName,
    required String ownerPhone,
    String? description,
    required double deliveryRadius,
    String? address,
    double? lat,
    double? lng,
    String? avatarUrl,
  }) async {
    final res = await _dio.post(
      '/api/merchant/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        'role': 'Merchant',
        'businessType': businessType,
        'restaurantName': restaurantName,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        if (description != null) 'description': description,
        'deliveryRadius': deliveryRadius,
        if (address != null) 'address': address,
        if (lat != null && lng != null) 'location': { 'lat': lat, 'lng': lng },
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      },
    );
    if (res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    throw Exception('Unexpected response');
  }
}
