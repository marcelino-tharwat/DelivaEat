import 'dart:async';
import 'package:deliva_eat/features/search/data/models/search_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/search/data/repos/search_repo.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/search/data/models/search_response_model.dart'; // تأكد من استيراد كل الموديلات
import 'package:deliva_eat/features/search/data/repos/search_repo.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo _searchRepo;
  Timer? _debounceTimer;
  String _lastQuery = '';
  bool _isLoadingMore = false;

  SearchCubit({required SearchRepo searchRepo})
      : _searchRepo = searchRepo,
        super(SearchInitial());

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _suggestionsTimer?.cancel();
    _suggestionsCache.clear();
    return super.close();
  }

  // Real-time search with debouncing
  void searchRealTime({
    required String query,
    String lang = 'ar',
    String type = 'all',
    int limit = 20,
    String? category,
    double? minRating,
    double? maxPrice,
    double? minPrice,
    Duration debounceTime = const Duration(milliseconds: 300),
  }) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      _lastQuery = '';
      emit(SearchInitial());
      getPopularSearches(lang: lang);
      return;
    }
    if (query == _lastQuery) return;
    _debounceTimer = Timer(debounceTime, () async {
      await _performSearch(
        query: query,
        lang: lang,
        type: type,
        limit: limit,
        page: 1,
        category: category,
        minRating: minRating,
        maxPrice: maxPrice,
        minPrice: minPrice,
      );
    });
  }

  // Regular search (immediate)
  Future<void> search({
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
    _debounceTimer?.cancel();
    await _performSearch(
      query: query,
      lang: lang,
      type: type,
      limit: limit,
      page: page,
      category: category,
      minRating: minRating,
      maxPrice: maxPrice,
      minPrice: minPrice,
    );
  }

  // Internal search method
  Future<void> _performSearch({
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
      final queryTrimmed = query.trim();
      if (queryTrimmed.isEmpty) {
        emit(SearchError(message: 'البحث لا يمكن أن يكون فارغاً'));
        return;
      }
      if (queryTrimmed.length < 2) {
        emit(SearchError(message: 'يجب أن يحتوي البحث على حرفين على الأقل'));
        return;
      }

      _lastQuery = queryTrimmed;
      
      if (page == 1) {
        emit(SearchLoading());
      }
      
      final result = await _searchRepo.globalSearch(
        query: queryTrimmed,
        lang: lang,
        type: type,
        limit: limit,
        page: page,
        category: category,
        minRating: minRating,
        maxPrice: maxPrice,
        minPrice: minPrice,
      );
      
      result.either(
        (error) { // Left (Failure)
          if (isClosed) return;
          String errorMessage = _getErrorMessage(error.errorMessage);
          emit(SearchError(message: errorMessage));
        },
        (searchResponse) { // Right (Success)
          if (isClosed) return;
          emit(SearchSuccess(
            restaurants: searchResponse.data.restaurants,
            foods: searchResponse.data.foods,
            total: searchResponse.data.total,
            page: searchResponse.data.page,
            totalPages: searchResponse.data.totalPages,
            query: queryTrimmed,
          ));
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(SearchError(message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'));
    }
  }

  // Enhanced error message handler
  String _getErrorMessage(String originalMessage) {
    // ... logic remains the same ...
    return originalMessage.isNotEmpty ? originalMessage : 'حدث خطأ أثناء البحث. يرجى المحاولة مرة أخرى.';
  }

  // Load more results
  Future<void> loadMore({
    required String query,
    required int nextPage,
    String lang = 'ar',
    String type = 'all',
    int limit = 20,
    String? category,
    double? minRating,
    double? maxPrice,
    double? minPrice,
  }) async {
    final currentState = state;
    if (currentState is! SearchSuccess || _isLoadingMore || currentState.page >= currentState.totalPages) return;
    
    _isLoadingMore = true;
    
    try {
      final result = await _searchRepo.globalSearch(
        query: query,
        lang: lang,
        type: type,
        limit: limit,
        page: nextPage,
        category: category,
        minRating: minRating,
        maxPrice: maxPrice,
        minPrice: minPrice,
      );
      
      result.either(
        (error) { // Left (Failure)
          if (isClosed) return;
          // Optionally emit a snackbar error message, but keep the current list.
        },
        (searchResponse) { // Right (Success)
          if (isClosed) return;
          
          final existingRestaurantIds = currentState.restaurants.map((r) => r.id).toSet();
          final existingFoodIds = currentState.foods.map((f) => f.id).toSet();
          
          final newRestaurants = searchResponse.data.restaurants.where((r) => !existingRestaurantIds.contains(r.id)).toList();
          final newFoods = searchResponse.data.foods.where((f) => !existingFoodIds.contains(f.id)).toList();
          
          emit(SearchSuccess(
            restaurants: [...currentState.restaurants, ...newRestaurants],
            foods: [...currentState.foods, ...newFoods],
            total: searchResponse.data.total,
            page: searchResponse.data.page,
            totalPages: searchResponse.data.totalPages,
            query: query,
          ));
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  // Optimized search suggestions
  Timer? _suggestionsTimer;
  final Map<String, List<SearchSuggestionModel>> _suggestionsCache = {};
  
  void getSuggestionsRealTime({
    required String query,
    String lang = 'ar',
    int limit = 5,
    Duration debounceTime = const Duration(milliseconds: 150),
  }) {
    _suggestionsTimer?.cancel();
    
    if (query.trim().isEmpty || query.length < 2) {
      emit(SearchSuggestionsSuccess(suggestions: []));
      return;
    }
    
    final cacheKey = '${query.toLowerCase()}_${lang}_$limit';
    if (_suggestionsCache.containsKey(cacheKey)) {
      emit(SearchSuggestionsSuccess(suggestions: _suggestionsCache[cacheKey]!));
      return;
    }
    
    _suggestionsTimer = Timer(debounceTime, () async {
      await _fetchSuggestions(query: query, lang: lang, limit: limit);
    });
  }

  Future<void> getSuggestions({
    required String query,
    String lang = 'ar',
    int limit = 5,
  }) async {
    _suggestionsTimer?.cancel();
    await _fetchSuggestions(query: query, lang: lang, limit: limit);
  }

  Future<void> _fetchSuggestions({
    required String query,
    String lang = 'ar',
    int limit = 5,
  }) async {
    try {
      final queryTrimmed = query.trim();
      if (queryTrimmed.length < 2) {
         emit(SearchSuggestionsSuccess(suggestions: []));
        return;
      }

      final cacheKey = '${queryTrimmed.toLowerCase()}_${lang}_$limit';
      if (_suggestionsCache.containsKey(cacheKey)) {
        emit(SearchSuggestionsSuccess(suggestions: _suggestionsCache[cacheKey]!));
        return;
      }

      emit(SearchSuggestionsLoading());
      
      final result = await _searchRepo.getSearchSuggestions(query: queryTrimmed, lang: lang, limit: limit);
      
      result.either(
        (error) { // Left (Failure)
          if (isClosed) return;
          emit(SearchSuggestionsError(message: _getErrorMessage(error.errorMessage)));
        },
        (suggestions) { // Right (Success)
          if (isClosed) return;
          if (_suggestionsCache.length > 20) _suggestionsCache.clear();
          _suggestionsCache[cacheKey] = suggestions;
          emit(SearchSuggestionsSuccess(suggestions: suggestions));
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(SearchSuggestionsError(message: 'فشل في تحميل الاقتراحات.'));
    }
  }

  // Get popular searches
  Future<void> getPopularSearches({
    String lang = 'ar',
    int limit = 10,
  }) async {
    emit(PopularSearchesLoading());
    
    final result = await _searchRepo.getPopularSearches(lang: lang, limit: limit);
    
    result.either(
      (error) { // Left (Failure)
        emit(PopularSearchesError(message: error.errorMessage));
      },
      (popularSearches) { // Right (Success)
        emit(PopularSearchesSuccess(popularSearches: popularSearches));
      },
    );
  }

  // Clear search results
  void clearSearch() {
    _lastQuery = '';
    _debounceTimer?.cancel();
    emit(SearchInitial());
  }

  // Quick search without changing state
Future<List<String>> quickSearch(String query) async {
  if (query.trim().isEmpty) {
    // Return early if query is empty
    return [];
  }
  
  final result = await _searchRepo.getSearchSuggestions(
    query: query,
    limit: 5,
  );

  // Use if/else to check the result and return the appropriate value
  if (result.isRight) {
    // If it's a success, access the value with .right and return it
    final suggestions = result.right; // result.right is of type List<SearchSuggestionModel>
    return suggestions.map((s) => s.name).toList();
  } else {
    // If it's a failure, return an empty list
    return [];
  }
}
}