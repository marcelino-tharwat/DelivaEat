import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/cart/data/models/cart_response.dart';

class CartRepo {
  final ApiService _apiService;
  CartRepo({required ApiService apiService}) : _apiService = apiService;

  Future<Either<ApiErrorHandler, CartData>> getCart(String lang) async {
    try {
      final res = await _apiService.getCart(lang);
      // dynamic response; convert to CartResponse
      if (res is Map<String, dynamic>) {
        final parsed = CartResponse.fromJson(res);
        return Right(parsed.data ?? CartData(ownerKey: '', items: const []));
      }
      return Left(ServerError('Unexpected cart response'));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e));
      }
      return Left(ServerError(e.toString()));
    }
  }

  Future<Either<ApiErrorHandler, void>> updateQuantity({
    required String id,
    required int quantity,
  }) async {
    try {
      await _apiService.updateCartItemQuantity(id, { 'quantity': quantity });
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e));
      }
      return Left(ServerError(e.toString()));
    }
  }

  Future<Either<ApiErrorHandler, void>> removeItem({
    required String id,
  }) async {
    try {
      await _apiService.removeCartItem(id);
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError.fromDioError(e));
      }
      return Left(ServerError(e.toString()));
    }
  }
}
