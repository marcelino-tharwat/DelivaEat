import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/features/home/data/models/home_response_model.dart';
import 'package:deliva_eat/features/home/data/models/category_model.dart';
import 'package:deliva_eat/features/home/data/models/offer_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo({required ApiService apiService}) : _apiService = apiService;

  Future<ApiResult<HomeResponseModel>> getHomeData(String lang) async {
    try {
      final response = await _apiService.getHomeData(lang);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CategoryModel>>> getCategories(String lang) async {
    try {
      final response = await _apiService.getCategories(lang);
      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<OfferModel>>> getOffers(String lang) async {
    try {
      final response = await _apiService.getOffers(lang);
      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<RestaurantModel>>> getRestaurants(
    String type,
    int limit,
    String lang,
  ) async {
    try {
      final response = await _apiService.getRestaurants(type, limit, lang);
      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<FoodModel>>> getBestSellingFoods(
    int limit,
    String lang,
  ) async {
    try {
      final response = await _apiService.getBestSellingFoods(limit, lang);
      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
