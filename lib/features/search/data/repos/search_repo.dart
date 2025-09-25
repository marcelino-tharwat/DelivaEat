// 1. استيراد المكتبات اللازمة
import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';

// 2. استيراد باقي ملفات المشروع
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/features/search/data/models/search_response_model.dart';
// تأكد من استيراد الموديلات الأخرى إذا كانت في ملفات منفصلة
// import 'package:deliva_eat/features/search/data/models/search_suggestion_model.dart';
// import 'package:deliva_eat/features/search/data/models/popular_search_model.dart';


class SearchRepo {
  final ApiService _apiService;

  SearchRepo({required ApiService apiService}) : _apiService = apiService;

  // الدالة الأولى تم تحويلها
  Future<Either<ApiErrorHandler, SearchResponseModel>> globalSearch({
    required String query,
    String lang = 'ar',
    String type = 'all',
    int limit = 20,
    int page = 1,
    String? category,
    double? minRating,
    double? maxPrice,
    double? minPrice,
  }) async {
    try {
      final response = await _apiService.globalSearch(
        query,
        lang,
        type,
        limit,
        page,
        category,
        minRating,
        maxPrice,
        minPrice,
      );
      // بما أن الـ response هو الموديل نفسه وليس مغلفًا، نرجعه مباشرة
      return Right(response);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }

  // الدالة الثانية تم تحويلها مع التعامل الآمن مع Null
  Future<Either<ApiErrorHandler, List<SearchSuggestionModel>>> getSearchSuggestions({
    required String query,
    String lang = 'ar',
    int limit = 5,
  }) async {
    try {
      final response = await _apiService.getSearchSuggestions(query, lang, limit);
      final data = response.data; // استخراج البيانات للتحقق منها
      
      return Right(data);
        } catch (error) {
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }

  // الدالة الثالثة تم تحويلها مع التعامل الآمن مع Null
  Future<Either<ApiErrorHandler, List<PopularSearchModel>>> getPopularSearches({
    String lang = 'ar',
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.getPopularSearches(lang, limit);
      final data = response.data; // استخراج البيانات للتحقق منها

      return Right(data);
        } catch (error) {
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }
}