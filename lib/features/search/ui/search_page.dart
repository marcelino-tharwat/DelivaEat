import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/features/search/cubit/search_cubit.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

import 'widgets/search_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_loading_widget.dart';
import 'widgets/search_error_widget.dart';
import 'widgets/search_empty_state.dart';
import 'widgets/search_suggestions.dart';
import 'widgets/popular_searches.dart';
import 'widgets/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late SearchCubit _searchCubit;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchCubit = getIt<SearchCubit>();
    _scrollController.addListener(_onScroll);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider<SearchCubit>.value(
      value: _searchCubit..getPopularSearches(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              SearchHeader(
                isSearchFocused: _isSearchFocused,
                onBackPressed: () => context.pop(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SearchBarWidget(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  isSearchFocused: _isSearchFocused,
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
                  onClear: () {
                    _searchController.clear();
                    _searchCubit.clearSearch();
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  bloc: _searchCubit,
                  builder: (context, state) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildSearchContent(context, state),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return const SearchLoadingWidget();
    }
    if (state is SearchError) {
      return SearchErrorWidget(
        message: state.message,
        onRetry: () {
          if (_searchController.text.isNotEmpty) {
            _searchCubit.search(query: _searchController.text);
          }
        },
      );
    }
    if (state is SearchSuccess) {
      return SearchResults(
        state: state,
        onRefresh: () => _searchCubit.search(query: state.query),
      );
    }
    if (state is SearchSuggestionsSuccess &&
        _searchController.text.isNotEmpty) {
      return SearchSuggestions(
        state: state,
        onSuggestionTap: (name) {
          _searchController.text = name;
          _searchCubit.search(query: name);
        },
      );
    }
    if (state is PopularSearchesSuccess) {
      return PopularSearches(
        state: state,
        onSearchTap: (term) {
          _searchController.text = term;
          _searchCubit.search(query: term);
        },
      );
    }
    return const SearchEmptyState();
  }
}
