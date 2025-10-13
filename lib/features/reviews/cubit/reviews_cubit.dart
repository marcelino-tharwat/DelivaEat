import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/reviews/cubit/reviews_state.dart';
import 'package:deliva_eat/features/reviews/data/repos/reviews_repo.dart';
import 'package:deliva_eat/features/reviews/data/models/review_create_request.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepo _repo;
  String? _foodId;
  String? _restaurantId;
  int _page = 1;
  int _limit = 20;
  bool _isLoadingMore = false;
  List reviewsCache = const [];

  ReviewsCubit({required ReviewsRepo repo})
      : _repo = repo,
        super(ReviewsInitial());

  void setContext({String? foodId, String? restaurantId, int limit = 20}) {
    _foodId = foodId;
    _restaurantId = restaurantId;
    _limit = limit;
  }

  Future<void> fetchReviews({int page = 1}) async {
    emit(ReviewsLoading());
    _page = page;
    final result = await _repo.getReviews(
      foodId: _foodId,
      restaurantId: _restaurantId,
      limit: _limit,
      page: _page,
    );
    result.either(
      (err) => emit(ReviewsError(err.errorMessage)),
      (data) {
        emit(ReviewsLoaded(
          items: data.items,
          total: data.total,
          page: data.page,
          limit: data.limit,
        ));
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    final current = state;
    if (current is! ReviewsLoaded) return;
    if (current.items.length >= current.total) return;

    _isLoadingMore = true;
    final nextPage = current.page + 1;
    final result = await _repo.getReviews(
      foodId: _foodId,
      restaurantId: _restaurantId,
      limit: _limit,
      page: nextPage,
    );
    result.either(
      (_) {},
      (data) {
        final newItems = [...current.items, ...data.items];
        emit(ReviewsLoaded(
          items: newItems,
          total: data.total,
          page: data.page,
          limit: data.limit,
        ));
      },
    );
    _isLoadingMore = false;
  }

  Future<void> submitReview({required int rating, required String comment}) async {
    emit(ReviewSubmitting());
    final req = ReviewCreateRequest(
      foodId: _foodId,
      restaurantId: _restaurantId,
      rating: rating,
      comment: comment,
    );
    final result = await _repo.addReview(req);
    result.either(
      (err) => emit(ReviewsError(err.errorMessage)),
      (review) {
        final current = state;
        if (current is ReviewsLoaded) {
          emit(ReviewsLoaded(
            items: [review, ...current.items],
            total: current.total + 1,
            page: current.page,
            limit: current.limit,
          ));
        } else {
          emit(ReviewsLoaded(items: [review], total: 1, page: 1, limit: _limit));
        }
        emit(ReviewSubmitted(review));
      },
    );
  }
}
