// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : AuthData.fromJson(json['data'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : AuthError.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
    };

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String?,
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
  'isActive': instance.isActive,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  role: json['role'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'avatarUrl': instance.avatarUrl,
  'role': instance.role,
  'createdAt': instance.createdAt.toIso8601String(),
};

AuthError _$AuthErrorFromJson(Map<String, dynamic> json) =>
    AuthError(code: json['code'] as String, message: json['message'] as String);

Map<String, dynamic> _$AuthErrorToJson(AuthError instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
};
