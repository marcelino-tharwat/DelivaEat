import 'package:deliva_eat/features/home/data/models/category_model.dart';
import 'package:deliva_eat/features/home/data/models/offer_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final List<RestaurantModel> favoriteRestaurants;
  final List<RestaurantModel> topRatedRestaurants;
  final List<FoodModel> bestSellingFoods;

  HomeSuccess({
    required this.categories,
    required this.offers,
    required this.favoriteRestaurants,
    required this.topRatedRestaurants,
    required this.bestSellingFoods,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}

// Individual states for specific sections
class CategoriesLoading extends HomeState {}

class CategoriesSuccess extends HomeState {
  final List<CategoryModel> categories;

  CategoriesSuccess({required this.categories});
}

class CategoriesError extends HomeState {
  final String message;

  CategoriesError({required this.message});
}

class OffersLoading extends HomeState {}

class OffersSuccess extends HomeState {
  final List<OfferModel> offers;

  OffersSuccess({required this.offers});
}

class OffersError extends HomeState {
  final String message;

  OffersError({required this.message});
}

class RestaurantsLoading extends HomeState {}

class RestaurantsSuccess extends HomeState {
  final List<RestaurantModel> restaurants;
  final String type;

  RestaurantsSuccess({required this.restaurants, required this.type});
}

class RestaurantsError extends HomeState {
  final String message;

  RestaurantsError({required this.message});
}

class BestSellingFoodsLoading extends HomeState {}

class BestSellingFoodsSuccess extends HomeState {
  final List<FoodModel> foods;

  BestSellingFoodsSuccess({required this.foods});
}

class BestSellingFoodsError extends HomeState {
  final String message;

  BestSellingFoodsError({required this.message});
}
