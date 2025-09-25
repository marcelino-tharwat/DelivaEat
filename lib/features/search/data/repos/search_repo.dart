import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/features/search/data/models/search_response_model.dart';

class SearchRepo {
  final ApiService _apiService;

  SearchRepo({required ApiService apiService}) : _apiService = apiService;

  Future<ApiResult<SearchResponseModel>> globalSearch({
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
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<SearchSuggestionModel>>> getSearchSuggestions({
    required String query,
    String lang = 'ar',
    int limit = 5,
  }) async {
    try {
      final response = await _apiService.getSearchSuggestions(query, lang, limit);
      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<PopularSearchModel>>> getPopularSearches({
    String lang = 'ar',
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.getPopularSearches(lang, limit);
      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
