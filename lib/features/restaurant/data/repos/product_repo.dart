import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/restaurant/data/models/cart_models.dart';
import 'package:deliva_eat/features/home/data/models/home_response_model.dart';

class ProductRepo {
  final ApiService _api;
  ProductRepo({required ApiService apiService}) : _api = apiService;

  Future<Either<ApiErrorHandler, CartItemModel>> addToCart({
    required String foodId,
    int quantity = 1,
    List<CartOption> options = const [],
    String lang = 'ar',
  }) async {
    try {
      final req = AddCartItemRequest(foodId: foodId, quantity: quantity, options: options);
      final res = await _api.addItemToCart(req, lang);
      final data = res.data;
      if (data == null) return Left(ServerError('Empty response'));
      return Right(data);
    } catch (e) {
      if (e is DioException) return Left(ServerError.fromDioError(e));
      return Left(ServerError(e.toString()));
    }
  }
}
