import 'package:deliva_eat/features/reviews/data/models/review_model.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<ReviewModel> items;
  final int total;
  final int page;
  final int limit;
  ReviewsLoaded({required this.items, required this.total, required this.page, required this.limit});
}

class ReviewsError extends ReviewsState {
  final String message;
  ReviewsError(this.message);
}

class ReviewSubmitting extends ReviewsState {}

class ReviewSubmitted extends ReviewsState {
  final ReviewModel review;
  ReviewSubmitted(this.review);
}
