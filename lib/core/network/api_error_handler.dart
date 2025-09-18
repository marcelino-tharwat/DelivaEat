import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

abstract class ApiErrorHandler {
  String errorMessage;
  ApiErrorHandler(this.errorMessage);
}

class ServerError extends ApiErrorHandler {
  ServerError(super.errorMessage);

  factory ServerError.fromDioError(
    DioException dioError,
    BuildContext context,
  ) {
    final loc = AppLocalizations.of(context)!;

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerError(loc.error_connection_timeout);
      case DioExceptionType.sendTimeout:
        return ServerError(loc.error_send_timeout);
      case DioExceptionType.receiveTimeout:
        return ServerError(loc.error_receive_timeout);
      case DioExceptionType.badCertificate:
        return ServerError(loc.error_bad_certificate);
      case DioExceptionType.badResponse:
        return ServerError.fromBadResponse(
          dioError.response!.statusCode!,
          dioError.response!.data,
          context,
        );
      case DioExceptionType.cancel:
        return ServerError(loc.error_request_cancelled);
      case DioExceptionType.connectionError:
        return ServerError(loc.error_connection_error);
      default:
        return ServerError(loc.error_unknown);
    }
  }

  factory ServerError.fromBadResponse(
    int statusCode,
    dynamic response,
    BuildContext context,
  ) {
    final loc = AppLocalizations.of(context)!;

    if (statusCode == 400 || statusCode == 401 || statusCode == 403|| statusCode == 409) {
      String message = _extractMessage(response, context);
      return ServerError(message);  
    } else if (statusCode == 404) {
      return ServerError(loc.error_not_found);
    } else if (statusCode == 500) {
      return ServerError(loc.error_internal_server);
    } else {
      return ServerError(loc.error_unknown);
    }
  }

 static String _extractMessage(dynamic response, BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  try {
    if (response == null) {
      return loc.error_unknown;
    }

    if (response is Map<String, dynamic>) {
      if (response.containsKey('message') && response['message'] != null) {
        return response['message'].toString();
      }
      if (response.containsKey('Message') && response['Message'] != null) {
        return response['Message'].toString();
      }
      if (response.containsKey('error') && response['error'] != null) {
        final error = response['error'];
        if (error is String) {
          return error;
        }
        if (error is Map<String, dynamic> && error.containsKey('message')) {
          return error['message'].toString();
        }
        return error.toString();
      }
      if (response.containsKey('msg') && response['msg'] != null) {
        return response['msg'].toString();
      }
      return response.toString();
    }

    if (response is String && response.isNotEmpty) {
      return response;
    }

    return response.toString();
  } catch (e) {
    return loc.error_processing_response;
  }
}
}
