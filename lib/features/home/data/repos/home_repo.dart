// 1. استيراد مكتبة either_dart
import 'package:either_dart/either.dart';

// 2. استيراد باقي الملفات المطلوبة
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/features/home/data/models/home_response_model.dart';
import 'package:deliva_eat/features/home/data/models/category_model.dart';
import 'package:deliva_eat/features/home/data/models/offer_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:dio/dio.dart'; // ستحتاج هذا للتعامل مع DioException

class HomeRepo {
  final ApiService _apiService;

  HomeRepo({required ApiService apiService}) : _apiService = apiService;

  // الدالة الأولى تم تحويلها
  Future<Either<ApiErrorHandler, HomeResponseModel>> getHomeData(
    String lang,
  ) async {
    try {
      final response = await _apiService.getHomeData(lang);
      return Right(response);
    } catch (error) {
      // استخدام نفس منطق التعامل مع الأخطاء في المثال
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }

  // الدالة الثانية تم تحويلها
  Future<Either<ApiErrorHandler, List<CategoryModel>>> getCategories(
    String lang,
  ) async {
    try {
      final response = await _apiService.getCategories(lang);
      final data = response.data; // استخراج البيانات في متغير
      if (data != null) {
        // إذا لم تكن البيانات null، أرجعها كـ Right
        return Right(data);
      } else {
        // إذا كانت البيانات null، أرجعها كـ Left مع رسالة خطأ مناسبة
        return Left(ServerError("The response from the server was empty."));
      }
    } catch (error) {
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }

  // الدالة الثالثة تم تحويلها
  Future<Either<ApiErrorHandler, List<OfferModel>>> getOffers(
    String lang,
  ) async {
    try {
      final response = await _apiService.getOffers(lang);
      final data = response.data;
      if (data != null) {
        return Right(data);
      } else {
        return Left(ServerError("The response from the server was empty."));
      }
    } catch (error) {
      // ... نفس الـ catch block
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }

  // الدالة الرابعة تم تحويلها
  Future<Either<ApiErrorHandler, List<RestaurantModel>>> getRestaurants(
    String type,
    int limit,
    String lang,
  ) async {
    try {
      final response = await _apiService.getRestaurants(type, limit, lang);
      final data = response.data;
      if (data != null) {
        return Right(data);
      } else {
        return Left(ServerError("The response from the server was empty."));
      }
    } catch (error) {
      // ... نفس الـ catch block
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }

  // الدالة الخامسة تم تحويلها
  Future<Either<ApiErrorHandler, List<FoodModel>>> getBestSellingFoods(
    int limit,
    String lang,
  ) async {
    try {
      final response = await _apiService.getBestSellingFoods(limit, lang);
      final data = response.data;
      if (data != null) {
        return Right(data);
      } else {
        return Left(ServerError("The response from the server was empty."));
      }
    } catch (error) {
      // ... نفس الـ catch block
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }
}
