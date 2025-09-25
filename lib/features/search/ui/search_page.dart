import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/features/search/cubit/search_cubit.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  
  late SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = getIt<SearchCubit>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more when reached bottom
      final currentState = _searchCubit.state;
      if (currentState is SearchSuccess && 
          currentState.page < currentState.totalPages) {
        _searchCubit.loadMore(
          query: currentState.query,
          nextPage: currentState.page + 1,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    
    return BlocProvider<SearchCubit>.value(
      value: _searchCubit..getPopularSearches(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.search ?? 'البحث'),
          elevation: 0,
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          bloc: _searchCubit,
          builder: (context, state) {
            return Column(
              children: [
                // Enhanced Search Bar with real-time search
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: appLocalizations.searchHint ?? 'ابحث عن مطاعم أو أطعمة...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _searchCubit.clearSearch();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      
                      // Real-time search with debouncing
                      if (value.isNotEmpty && value.length >= 2) {
                        _searchCubit.searchRealTime(query: value);
                        // Also get suggestions for autocomplete
                        _searchCubit.getSuggestionsRealTime(query: value);
                      } else if (value.isEmpty) {
                        _searchCubit.clearSearch();
                      }
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty && value.length >= 2) {
                        _searchCubit.search(query: value);
                        _searchFocusNode.unfocus();
                      }
                    },
                  ),
                ),
                
                // Search Results/Content with scroll controller
                Expanded(
                  child: _buildSearchContent(context, state, appLocalizations),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, SearchState state, AppLocalizations appLocalizations) {
    if (state is SearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  context.read<SearchCubit>().search(query: _searchController.text);
                }
              },
              child: Text(appLocalizations.retry ?? 'إعادة المحاولة'),
            ),
          ],
        ),
      );
    }
    
    if (state is SearchSuccess) {
      return _buildSearchResults(context, state, appLocalizations);
    }
    
    if (state is SearchSuggestionsSuccess && _searchController.text.isNotEmpty) {
      return _buildSuggestions(context, state, appLocalizations);
    }
    
    if (state is PopularSearchesSuccess) {
      return _buildPopularSearches(context, state, appLocalizations);
    }
    
    return _buildEmptyState(context, appLocalizations);
  }

  Widget _buildSearchResults(BuildContext context, SearchSuccess state, AppLocalizations appLocalizations) {
    return RefreshIndicator(
      onRefresh: () async {
        await _searchCubit.search(query: state.query);
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _calculateTotalItems(state),
        itemBuilder: (context, index) {
          return _buildResultItem(context, state, index, appLocalizations);
        },
      ),
    );
  }

  int _calculateTotalItems(SearchSuccess state) {
    int items = 0;
    if (state.restaurants.isNotEmpty) {
      items += 1; // Header
      items += state.restaurants.length;
    }
    if (state.foods.isNotEmpty) {
      items += 1; // Header
      items += state.foods.length;
    }
    if (state.restaurants.isEmpty && state.foods.isEmpty) {
      items = 1; // Empty state
    }
    if (state.page < state.totalPages) {
      items += 1; // Loading indicator
    }
    return items;
  }

  Widget _buildResultItem(BuildContext context, SearchSuccess state, int index, AppLocalizations appLocalizations) {
    int currentIndex = 0;
    
    // Restaurants section
    if (state.restaurants.isNotEmpty) {
      if (index == currentIndex) {
        return _buildSectionHeader('${appLocalizations.restaurants ?? 'المطاعم'} (${state.restaurants.length})', context);
      }
      currentIndex++;
      
      if (index < currentIndex + state.restaurants.length) {
        final restaurant = state.restaurants[index - currentIndex];
        return _buildRestaurantTile(restaurant);
      }
      currentIndex += state.restaurants.length;
    }
    
    // Foods section
    if (state.foods.isNotEmpty) {
      if (index == currentIndex) {
        return _buildSectionHeader('${appLocalizations.foods ?? 'الأطعمة'} (${state.foods.length})', context);
      }
      currentIndex++;
      
      if (index < currentIndex + state.foods.length) {
        final food = state.foods[index - currentIndex];
        return _buildFoodTile(food);
      }
      currentIndex += state.foods.length;
    }
    
    // Empty state
    if (state.restaurants.isEmpty && state.foods.isEmpty && index == currentIndex) {
      return _buildEmptySearchResult(state.query);
    }
    
    // Load more indicator
    if (state.page < state.totalPages && index == currentIndex) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRestaurantTile(RestaurantModel restaurant) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            restaurant.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant),
            ),
          ),
        ),
        title: Text(restaurant.nameAr, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('⭐ ${restaurant.rating} • ${restaurant.deliveryTime}'),
            Text('رسوم التوصيل: ${restaurant.deliveryFee} ريال'),
          ],
        ),
        onTap: () {
          // Navigate to restaurant details
        },
      ),
    );
  }

  Widget _buildFoodTile(FoodModel food) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            food.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.fastfood),
            ),
          ),
        ),
        title: Text(food.nameAr, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${food.price} ريال • ⭐ ${food.rating}'),
            if (food.restaurant != null)
              Text('من: ${food.restaurant!.nameAr}', 
                   style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: food.originalPrice != null && food.originalPrice! > food.price
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${food.originalPrice} ريال',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    'خصم!',
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              )
            : null,
        onTap: () {
          // Navigate to food details
        },
      ),
    );
  }

  Widget _buildEmptySearchResult(String query) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج للبحث "$query"',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب كلمات مختلفة أو تحقق من الإملاء',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Old method - converted to use new optimized structure above
  Widget _buildSearchResultsOld(BuildContext context, SearchSuccess state, AppLocalizations appLocalizations) {
    return ListView(
        if (state.restaurants.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${appLocalizations.restaurants ?? 'المطاعم'} (${state.restaurants.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ...state.restaurants.map((restaurant) => ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                restaurant.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant),
                ),
              ),
            ),
            title: Text(restaurant.nameAr),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('⭐ ${restaurant.rating} • ${restaurant.deliveryTime}'),
                Text('رسوم التوصيل: ${restaurant.deliveryFee} ريال'),
              ],
            ),
            onTap: () {
              // Navigate to restaurant details
            },
          )),
        ],
        
        if (state.foods.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${appLocalizations.foods ?? 'الأطعمة'} (${state.foods.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ...state.foods.map((food) => ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fastfood),
                ),
              ),
            ),
            title: Text(food.nameAr),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${food.price} ريال • ⭐ ${food.rating}'),
                if (food.restaurant != null)
                  Text('من: ${food.restaurant!.nameAr}'),
              ],
            ),
            trailing: food.originalPrice != null && food.originalPrice! > food.price
                ? Text(
                    '${food.originalPrice} ريال',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  )
                : null,
            onTap: () {
              // Navigate to food details
            },
          )),
        ],
        
        if (state.restaurants.isEmpty && state.foods.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد نتائج للبحث "${state.query}"',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context, SearchSuggestionsSuccess state, AppLocalizations appLocalizations) {
    return ListView.builder(
      itemCount: state.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return ListTile(
          leading: Icon(
            suggestion.type == 'restaurant' ? Icons.restaurant : Icons.fastfood,
          ),
          title: Text(suggestion.name),
          subtitle: suggestion.restaurant != null 
              ? Text('من: ${suggestion.restaurant}')
              : null,
          onTap: () {
            _searchController.text = suggestion.name;
            context.read<SearchCubit>().search(query: suggestion.name);
          },
        );
      },
    );
  }

  Widget _buildPopularSearches(BuildContext context, PopularSearchesSuccess state, AppLocalizations appLocalizations) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            appLocalizations.popularSearches ?? 'البحث الشائع',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Wrap(
          children: state.popularSearches
              .map((search) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ActionChip(
                      label: Text(search.term),
                      onPressed: () {
                        _searchController.text = search.term;
                        context.read<SearchCubit>().search(query: search.term);
                      },
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations appLocalizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            appLocalizations.searchEmpty ?? 'ابحث عن مطاعمك المفضلة وأطعمتك المفضلة',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
