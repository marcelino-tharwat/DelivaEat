import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/features/search/data/models/search_response_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<RestaurantModel> restaurants;
  final List<FoodModel> foods;
  final int total;
  final int page;
  final int totalPages;
  final String query;

  SearchSuccess({
    required this.restaurants,
    required this.foods,
    required this.total,
    required this.page,
    required this.totalPages,
    required this.query,
  });
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}

class SearchSuggestionsLoading extends SearchState {}

class SearchSuggestionsSuccess extends SearchState {
  final List<SearchSuggestionModel> suggestions;

  SearchSuggestionsSuccess({required this.suggestions});
}

class SearchSuggestionsError extends SearchState {
  final String message;

  SearchSuggestionsError({required this.message});
}

class PopularSearchesLoading extends SearchState {}

class PopularSearchesSuccess extends SearchState {
  final List<PopularSearchModel> popularSearches;

  PopularSearchesSuccess({required this.popularSearches});
}

class PopularSearchesError extends SearchState {
  final String message;

  PopularSearchesError({required this.message});
}
