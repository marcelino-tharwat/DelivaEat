# Refactor RestaurantHomePage to use Cubit

## Pending Tasks
- [x] Create restaurant_details_state.dart with states: RestaurantDetailsInitial, RestaurantDetailsLoading, RestaurantDetailsSuccess (containing restaurant, tabs, badges, itemsByTab, selectedCategory, isFavorite), RestaurantDetailsFailure.
- [x] Create restaurant_details_cubit.dart with methods: fetchDetails (fetches restaurant details and initial tab items), fetchItemsForTab (fetches items for a specific tab), toggleFavorite (integrates with HomeCubit, optimistic UI, rollback on error).
- [ ] Refactor restaurant_page.dart to StatelessWidget using BlocProvider (providing the cubit), BlocBuilder for UI rendering, BlocListener for side effects (snackbars, navigation).
- [ ] Move UI-specific logic like scroll controller, category keys, and tab selection to the widget.
- [ ] Preserve existing UI behavior, including WillPopScope with state-based data return.

## Completed Tasks
- [x] Analyze current code and create refactoring plan.
- [x] Get user approval for the plan.
