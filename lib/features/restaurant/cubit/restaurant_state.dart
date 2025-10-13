import 'package:deliva_eat/features/restaurant/data/models/restaurant_details_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';

abstract class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final RestaurantDetailsData details;
  final Map<String, List<FoodModel>> itemsByTab;
  final Set<String> loadingTabs;
  final bool isFavorite;

  RestaurantLoaded({
    required this.details,
    required this.itemsByTab,
    required this.loadingTabs,
    required this.isFavorite,
  });

  RestaurantLoaded copyWith({
    RestaurantDetailsData? details,
    Map<String, List<FoodModel>>? itemsByTab,
    Set<String>? loadingTabs,
    bool? isFavorite,
  }) => RestaurantLoaded(
    details: details ?? this.details,
    itemsByTab: itemsByTab ?? this.itemsByTab,
    loadingTabs: loadingTabs ?? this.loadingTabs,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
}
