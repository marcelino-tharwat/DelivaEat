import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/restaurant/data/models/restaurant_details_model.dart';
import 'package:deliva_eat/features/home/data/models/home_response_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';

class RestaurantRepo {
  final ApiService _api;
  RestaurantRepo({required ApiService apiService}) : _api = apiService;

  Future<Either<ApiErrorHandler, RestaurantDetailsData>> getRestaurantDetails({
    required String restaurantId,
    String lang = 'ar',
  }) async {
    try {
      final res = await _api.getRestaurantDetails(restaurantId, lang);
      final data = res.data;
      if (data == null) return Left(ServerError('Empty details response'));
      return Right(data);
    } catch (e) {
      if (e is DioException) return Left(ServerError.fromDioError(e));
      return Left(ServerError(e.toString()));
    }
  }

  Future<Either<ApiErrorHandler, List<FoodModel>>> getFoodsByRestaurant({
    required String restaurantId,
    int limit = 50,
    String lang = 'ar',
    String? tab,
    String? type,
  }) async {
    try {
      final res = await _api.getFoodsByRestaurant(restaurantId, limit, lang, tab, type);
      return Right(res.data ?? <FoodModel>[]);
    } catch (e) {
      if (e is DioException) return Left(ServerError.fromDioError(e));
      return Left(ServerError(e.toString()));
    }
  }

  Future<Either<ApiErrorHandler, bool>> toggleFavorite({
    required String restaurantId,
    String lang = 'ar',
  }) async {
    try {
      final res = await _api.toggleRestaurantFavorite({'restaurantId': restaurantId}, lang);
      return Right(res.success);
    } catch (e) {
      if (e is DioException) return Left(ServerError.fromDioError(e));
      return Left(ServerError(e.toString()));
    }
  }
}
