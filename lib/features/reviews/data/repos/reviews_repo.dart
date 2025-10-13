import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/core/network/api_service.dart';
import 'package:deliva_eat/features/reviews/data/models/review_create_request.dart';
import 'package:deliva_eat/features/reviews/data/models/review_list_response.dart';
import 'package:deliva_eat/features/reviews/data/models/review_model.dart';
import 'package:deliva_eat/features/home/data/models/home_response_model.dart';

class ReviewsRepo {
  final ApiService _apiService;
  ReviewsRepo({required ApiService apiService}) : _apiService = apiService;

  Future<Either<ApiErrorHandler, ReviewsListData>> getReviews({
    String? foodId,
    String? restaurantId,
    int limit = 20,
    int page = 1,
  }) async {
    try {
      final res = await _apiService.getReviews(foodId, restaurantId, limit, page);
      final data = res.data;
      return Right(data ?? ReviewsListData(items: const [], total: 0, page: 1, limit: limit));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerError.fromDioError(error));
      } else {
        return Left(ServerError(error.toString()));
      }
    }
  }

  Future<Either<ApiErrorHandler, ReviewModel>> addReview(ReviewCreateRequest request) async {
    try {
      final res = await _apiService.addReview(request);
      final data = res.data;
      if (data == null) return Left(ServerError('Empty response'));
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
