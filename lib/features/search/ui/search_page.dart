import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/features/search/cubit/search_cubit.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';

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
      final currentState = _searchCubit.state;
      if (currentState is SearchSuccess && currentState.page < currentState.totalPages) {
        _searchCubit.loadMore(
          query: currentState.query,
          nextPage: currentState.page + 1,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>.value(
      value: _searchCubit..getPopularSearches(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("البحث"),
          elevation: 0,
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          bloc: _searchCubit,
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: "ابحث عن مطاعم أو أطعمة...",
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
                      if (value.isNotEmpty && value.length >= 2) {
                        _searchCubit.searchRealTime(query: value);
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
                Expanded(
                  child: _buildSearchContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  context.read<SearchCubit>().search(query: _searchController.text);
                }
              },
              child: const Text("إعادة المحاولة"),
            ),
          ],
        ),
      );
    }

    if (state is SearchSuccess) {
      return _buildSearchResults(context, state);
    }

    if (state is SearchSuggestionsSuccess && _searchController.text.isNotEmpty) {
      return _buildSuggestions(context, state);
    }

    if (state is PopularSearchesSuccess) {
      return _buildPopularSearches(context, state);
    }

    return _buildEmptyState();
  }

  Widget _buildSearchResults(BuildContext context, SearchSuccess state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _searchCubit.search(query: state.query);
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _calculateTotalItems(state),
        itemBuilder: (context, index) {
          return _buildResultItem(context, state, index);
        },
      ),
    );
  }

  int _calculateTotalItems(SearchSuccess state) {
    int items = 0;
    if (state.restaurants.isNotEmpty) {
      items += 1;
      items += state.restaurants.length;
    }
    if (state.foods.isNotEmpty) {
      items += 1;
      items += state.foods.length;
    }
    if (state.restaurants.isEmpty && state.foods.isEmpty) {
      items = 1;
    }
    if (state.page < state.totalPages) {
      items += 1;
    }
    return items;
  }

  Widget _buildResultItem(BuildContext context, SearchSuccess state, int index) {
    int currentIndex = 0;

    if (state.restaurants.isNotEmpty) {
      if (index == currentIndex) {
        return _buildSectionHeader("المطاعم (${state.restaurants.length})", context);
      }
      currentIndex++;

      if (index < currentIndex + state.restaurants.length) {
        final restaurant = state.restaurants[index - currentIndex];
        return _buildRestaurantTile(restaurant);
      }
      currentIndex += state.restaurants.length;
    }

    if (state.foods.isNotEmpty) {
      if (index == currentIndex) {
        return _buildSectionHeader("الأطعمة (${state.foods.length})", context);
      }
      currentIndex++;

      if (index < currentIndex + state.foods.length) {
        final food = state.foods[index - currentIndex];
        return _buildFoodTile(food);
      }
      currentIndex += state.foods.length;
    }

    if (state.restaurants.isEmpty && state.foods.isEmpty && index == currentIndex) {
      return _buildEmptySearchResult(state.query);
    }

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
            Text("⭐ ${restaurant.rating} • ${restaurant.deliveryTime}"),
            Text("رسوم التوصيل: ${restaurant.deliveryFee} ريال"),
          ],
        ),
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
            Text("${food.price} ريال • ⭐ ${food.rating}"),
            if (food.restaurant != null)
              Text("من: ${food.restaurant!.nameAr}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: food.originalPrice != null && food.originalPrice! > food.price
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${food.originalPrice} ريال",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const Text("خصم!", style: TextStyle(color: Colors.red, fontSize: 10)),
                ],
              )
            : null,
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
            "جرب كلمات مختلفة أو تحقق من الإملاء",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, SearchSuggestionsSuccess state) {
    return ListView.builder(
      itemCount: state.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return ListTile(
          leading: Icon(suggestion.type == "restaurant" ? Icons.restaurant : Icons.fastfood),
          title: Text(suggestion.name),
          subtitle: suggestion.restaurant != null ? Text("من: ${suggestion.restaurant}") : null,
          onTap: () {
            _searchController.text = suggestion.name;
            context.read<SearchCubit>().search(query: suggestion.name);
          },
        );
      },
    );
  }

  Widget _buildPopularSearches(BuildContext context, PopularSearchesSuccess state) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("البحث الشائع", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("ابحث عن مطاعمك المفضلة وأطعمتك المفضلة", textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
