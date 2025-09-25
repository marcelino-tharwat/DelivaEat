import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/search/data/repos/search_repo.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';

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

  // Real-time search with debouncing - نتائج فورية مع تحسين الأداء
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
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // If query is empty, show initial state
    if (query.trim().isEmpty) {
      _lastQuery = '';
      emit(SearchInitial());
      getPopularSearches(lang: lang);
      return;
    }
    
    // If query hasn't changed, don't search again
    if (query == _lastQuery) return;
    
    // Debounce search to avoid excessive API calls
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

  // Internal search method with comprehensive error handling
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
      
      // Validation
      if (queryTrimmed.isEmpty) {
        emit(SearchError(message: 'البحث لا يمكن أن يكون فارغاً'));
        return;
      }
      
      if (queryTrimmed.length < 2) {
        emit(SearchError(message: 'يجب أن يحتوي البحث على حرفين على الأقل'));
        return;
      }

      _lastQuery = queryTrimmed;
      
      // Show loading only for first page
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
      
      result.when(
        success: (searchResponse) {
          // Performance optimization: check if component is still mounted
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
        failure: (error) {
          if (isClosed) return;
          
          // Enhanced error handling with user-friendly messages
          String errorMessage = _getErrorMessage(error.apiErrorModel.message);
          emit(SearchError(message: errorMessage));
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(SearchError(message: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'));
    }
  }

  // Enhanced error message handler
  String _getErrorMessage(String originalMessage) {
    if (originalMessage.toLowerCase().contains('network')) {
      return 'تعذر الاتصال بالخادم. تحقق من اتصال الإنترنت.';
    }
    if (originalMessage.toLowerCase().contains('timeout')) {
      return 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';
    }
    if (originalMessage.toLowerCase().contains('empty_query')) {
      return 'يرجى كتابة ما تريد البحث عنه.';
    }
    if (originalMessage.toLowerCase().contains('rate_limited')) {
      return 'تم تجاوز الحد الأقصى للبحث. يرجى الانتظار قليلاً.';
    }
    return originalMessage.isNotEmpty ? originalMessage : 'حدث خطأ أثناء البحث. يرجى المحاولة مرة أخرى.';
  }

  // Performance optimized load more with duplicate prevention
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
    if (currentState is! SearchSuccess) return;
    
    // Prevent multiple simultaneous load more requests
    if (_isLoadingMore) return;
    
    // Check if there are more pages to load
    if (currentState.page >= currentState.totalPages) return;
    
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
      
      result.when(
        success: (searchResponse) {
          if (isClosed) return;
          
          // Performance optimization: Use Sets to prevent duplicates
          final existingRestaurantIds = currentState.restaurants.map((r) => r.id).toSet();
          final existingFoodIds = currentState.foods.map((f) => f.id).toSet();
          
          final newRestaurants = searchResponse.data.restaurants
              .where((r) => !existingRestaurantIds.contains(r.id))
              .toList();
          
          final newFoods = searchResponse.data.foods
              .where((f) => !existingFoodIds.contains(f.id))
              .toList();
          
          emit(SearchSuccess(
            restaurants: [...currentState.restaurants, ...newRestaurants],
            foods: [...currentState.foods, ...newFoods],
            total: searchResponse.data.total,
            page: searchResponse.data.page,
            totalPages: searchResponse.data.totalPages,
            query: query,
          ));
        },
        failure: (error) {
          // Keep current state - don't break the list
          if (isClosed) return;
          // Could emit a specific error state for load more failure
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  // Optimized search suggestions with caching and debouncing
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
    
    // Check cache first for performance
    final cacheKey = '${query.toLowerCase()}_${lang}_$limit';
    if (_suggestionsCache.containsKey(cacheKey)) {
      emit(SearchSuggestionsSuccess(suggestions: _suggestionsCache[cacheKey]!));
      return;
    }
    
    _suggestionsTimer = Timer(debounceTime, () async {
      await _fetchSuggestions(query: query, lang: lang, limit: limit);
    });
  }

  // Get search suggestions (immediate)
  Future<void> getSuggestions({
    required String query,
    String lang = 'ar',
    int limit = 5,
  }) async {
    _suggestionsTimer?.cancel();
    await _fetchSuggestions(query: query, lang: lang, limit: limit);
  }

  // Internal suggestions fetch method
  Future<void> _fetchSuggestions({
    required String query,
    String lang = 'ar',
    int limit = 5,
  }) async {
    try {
      final queryTrimmed = query.trim();
      
      if (queryTrimmed.isEmpty) {
        emit(SearchSuggestionsSuccess(suggestions: []));
        return;
      }

      if (queryTrimmed.length < 2) {
        return; // Don't show loading for very short queries
      }

      // Check cache
      final cacheKey = '${queryTrimmed.toLowerCase()}_${lang}_$limit';
      if (_suggestionsCache.containsKey(cacheKey)) {
        emit(SearchSuggestionsSuccess(suggestions: _suggestionsCache[cacheKey]!));
        return;
      }

      emit(SearchSuggestionsLoading());
      
      final result = await _searchRepo.getSearchSuggestions(
        query: queryTrimmed,
        lang: lang,
        limit: limit,
      );
      
      result.when(
        success: (suggestions) {
          if (isClosed) return;
          
          // Cache results for performance (limit cache size)
          if (_suggestionsCache.length > 20) {
            _suggestionsCache.clear();
          }
          _suggestionsCache[cacheKey] = suggestions;
          
          emit(SearchSuggestionsSuccess(suggestions: suggestions));
        },
        failure: (error) {
          if (isClosed) return;
          emit(SearchSuggestionsError(message: _getErrorMessage(error.apiErrorModel.message)));
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
    
    final result = await _searchRepo.getPopularSearches(
      lang: lang,
      limit: limit,
    );
    
    result.when(
      success: (popularSearches) {
        emit(PopularSearchesSuccess(popularSearches: popularSearches));
      },
      failure: (error) {
        emit(PopularSearchesError(message: error.apiErrorModel.message));
      },
    );
  }

  // Clear search results
  void clearSearch() {
    emit(SearchInitial());
  }

  // Quick search without changing state (for suggestions)
  Future<List<String>> quickSearch(String query) async {
    if (query.trim().isEmpty) return [];
    
    final result = await _searchRepo.getSearchSuggestions(
      query: query,
      limit: 5,
    );
    
    return result.when(
      success: (suggestions) => suggestions.map((s) => s.name).toList(),
      failure: (_) => [],
    );
  }
}
