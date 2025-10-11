import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/home/data/repos/home_repo.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit({required HomeRepo homeRepo}) 
      : _homeRepo = homeRepo,
        super(HomeInitial());

  // Get all home data at once
  Future<void> getHomeData({String lang = 'ar'}) async {
    emit(HomeLoading());

    final result = await _homeRepo.getHomeData(lang);
    result.fold(
      (error) { // الدالة الأولى: حالة الفشل (Left)
        // ملاحظة: تأكد من أن كلاس الخطأ لديك يحتوي على 'message' أو 'errorMessage'
        emit(HomeError(message: error.errorMessage)); 
      },
      (homeResponse) { // الدالة الثانية: حالة النجاح (Right)
        final favFoods = homeResponse.data.bestSellingFoods
            .where((f) => f.isFavorite == true)
            .toList();
        emit(HomeSuccess(
          categories: homeResponse.data.categories,
          offers: homeResponse.data.offers,
          favoriteRestaurants: homeResponse.data.favoriteRestaurants,
          topRatedRestaurants: homeResponse.data.topRatedRestaurants,
          bestSellingFoods: homeResponse.data.bestSellingFoods,
          favoriteFoods: favFoods,
        ));
      },
    );
  }

  // Toggle food favorite (best selling list) with optimistic UI
  Future<void> toggleFoodFavorite({required String foodId, String lang = 'ar', FoodModel? baseOverride}) async {
    final current = state;
    if (current is! HomeSuccess) return;

    final exists = current.bestSellingFoods.any((f) => f.id == foodId);
    // proceed even if not in best-selling to keep favoriteFoods consistent

    final beforeBest = current.bestSellingFoods;
    final toggledBest = beforeBest
        .map((f) => f.id == foodId
            ? FoodModel(
                id: f.id,
                name: f.name,
                nameAr: f.nameAr,
                description: f.description,
                descriptionAr: f.descriptionAr,
                image: f.image,
                price: f.price,
                originalPrice: f.originalPrice,
                rating: f.rating,
                reviewCount: f.reviewCount,
                preparationTime: f.preparationTime,
                isAvailable: f.isAvailable,
                isPopular: f.isPopular,
                isBestSelling: f.isBestSelling,
                isFavorite: !(f.isFavorite ?? false),
                restaurant: f.restaurant,
                ingredients: f.ingredients,
                allergens: f.allergens,
                tags: f.tags,
              )
            : f)
        .toList();

    // compute optimistic favoriteFoods
    final isInFavorites = current.favoriteFoods.any((ff) => ff.id == foodId);
    List<FoodModel> toggledFavFoods = current.favoriteFoods;
    if (isInFavorites) {
      // remove if currently in favorites (since we're toggling)
      toggledFavFoods = current.favoriteFoods.where((ff) => ff.id != foodId).toList();
    } else {
      // if present in best-selling, and toggled to true, add it; otherwise we can't safely add
      FoodModel? maybeBest;
      for (final f in toggledBest) {
        if (f.id == foodId) {
          maybeBest = f;
          break;
        }
      }
      if (maybeBest != null && (maybeBest!.isFavorite ?? false)) {
        toggledFavFoods = [maybeBest!, ...current.favoriteFoods];
      } else if (baseOverride != null) {
        final candidate = (baseOverride.isFavorite ?? false)
            ? baseOverride
            : FoodModel(
                id: baseOverride.id,
                name: baseOverride.name,
                nameAr: baseOverride.nameAr,
                description: baseOverride.description,
                descriptionAr: baseOverride.descriptionAr,
                image: baseOverride.image,
                price: baseOverride.price,
                originalPrice: baseOverride.originalPrice,
                rating: baseOverride.rating,
                reviewCount: baseOverride.reviewCount,
                preparationTime: baseOverride.preparationTime,
                isAvailable: baseOverride.isAvailable,
                isPopular: baseOverride.isPopular,
                isBestSelling: baseOverride.isBestSelling,
                isFavorite: true,
                restaurant: baseOverride.restaurant,
                ingredients: baseOverride.ingredients,
                allergens: baseOverride.allergens,
                tags: baseOverride.tags,
              );
        toggledFavFoods = [candidate, ...current.favoriteFoods.where((ff) => ff.id != foodId)];
      }
    }

    emit(
      HomeSuccess(
        categories: current.categories,
        offers: current.offers,
        favoriteRestaurants: current.favoriteRestaurants,
        topRatedRestaurants: current.topRatedRestaurants,
        bestSellingFoods: toggledBest,
        favoriteFoods: toggledFavFoods,
      ),
    );

    final result = await _homeRepo.toggleFoodFavorite(foodId, lang);
    result.fold(
      (error) {
        // rollback
        emit(current);
      },
      (updated) {
        // reconcile only this food item
        final curr = state;
        if (curr is HomeSuccess) {
          final reconciled = curr.bestSellingFoods
              .map((f) => f.id == foodId
                  ? FoodModel(
                      id: updated.id,
                      name: updated.name,
                      nameAr: updated.nameAr,
                      description: updated.description,
                      descriptionAr: updated.descriptionAr,
                      image: updated.image,
                      price: updated.price,
                      originalPrice: updated.originalPrice,
                      rating: updated.rating,
                      reviewCount: updated.reviewCount,
                      preparationTime: updated.preparationTime,
                      isAvailable: updated.isAvailable,
                      isPopular: updated.isPopular,
                      isBestSelling: updated.isBestSelling,
                      isFavorite: updated.isFavorite,
                      restaurant: updated.restaurant,
                      ingredients: updated.ingredients,
                      allergens: updated.allergens,
                      tags: updated.tags,
                    )
                  : f)
              .toList();
          // reconcile favoriteFoods
          List<FoodModel> reconciledFavFoods;
          final serverFav = updated.isFavorite == true;
          final alreadyFav = curr.favoriteFoods.any((ff) => ff.id == foodId);
          if (serverFav) {
            if (alreadyFav) {
              reconciledFavFoods = curr.favoriteFoods
                  .map((ff) => ff.id == foodId ? updated : ff)
                  .toList();
            } else {
              final toAdd = updated;
              reconciledFavFoods = [toAdd, ...curr.favoriteFoods];
            }
          } else {
            reconciledFavFoods = curr.favoriteFoods.where((ff) => ff.id != foodId).toList();
          }
          emit(
            HomeSuccess(
              categories: curr.categories,
              offers: curr.offers,
              favoriteRestaurants: curr.favoriteRestaurants,
              topRatedRestaurants: curr.topRatedRestaurants,
              bestSellingFoods: reconciled,
              favoriteFoods: reconciledFavFoods,
            ),
          );
        }
      },
    );
  }
  // Get categories only
  Future<void> getCategories({String lang = 'ar'}) async {
    emit(CategoriesLoading());

    final result = await _homeRepo.getCategories(lang);
    result.fold(
      (error) {
        emit(CategoriesError(message: error.errorMessage));
      },
      (categories) {
        emit(CategoriesSuccess(categories: categories));
      },
    );
  }
  // Get offers only
   Future<void> getOffers({String lang = 'ar'}) async {
    emit(OffersLoading());

    final result = await _homeRepo.getOffers(lang);
    result.fold(
      (error) {
        emit(OffersError(message: error.errorMessage));
      },
      (offers) {
        emit(OffersSuccess(offers: offers));
      },
    );
  }

  // Get restaurants by type
  Future<void> getRestaurants({
    String type = 'all',
    int limit = 10,
    String lang = 'ar',
  }) async {
    emit(RestaurantsLoading());
    
    final result = await _homeRepo.getRestaurants(type, limit, lang);
    result.fold(
      (error) {
        emit(RestaurantsError(message: error.errorMessage));
      },
     (restaurants) {
        emit(RestaurantsSuccess(restaurants: restaurants, type: type));
      }
      
    );
  }

  // Get best selling foods
  Future<void> getBestSellingFoods({
    int limit = 15,
    String lang = 'ar',
  }) async {
    emit(BestSellingFoodsLoading());

    final result = await _homeRepo.getBestSellingFoods(limit, lang);
    result.fold(
      (error) {
        emit(BestSellingFoodsError(message: error.errorMessage));
      },
      (foods) {
        emit(BestSellingFoodsSuccess(foods: foods));
      },
    );
  }

  // Refresh home data
  Future<void> refreshHomeData({String lang = 'ar'}) async {
    await getHomeData(lang: lang);
  }

  // Toggle restaurant favorite with optimistic UI update
  Future<void> toggleFavorite({
    required String restaurantId,
    String lang = 'ar',
    RestaurantModel? baseOverride,
  }) async {
    final current = state;
    if (current is! HomeSuccess) return;

    // Find the restaurant in any list to know current favorite state
    RestaurantModel? base = baseOverride ?? (
      [...current.favoriteRestaurants, ...current.topRatedRestaurants]
    ).firstWhere(
      (r) => r.id == restaurantId,
      orElse: () => RestaurantModel(
        id: restaurantId,
        name: '',
        nameAr: '',
        image: '',
        rating: 0,
        reviewCount: 0,
        deliveryTime: null,
        deliveryFee: null,
        minimumOrder: null,
        isOpen: null,
        isActive: null,
        isFavorite: false,
        isTopRated: null,
        address: null,
        phone: null,
        description: null,
        descriptionAr: null,
        coverImage: null,
      ),
    );

    final bool newFav = !(base.isFavorite ?? false);

    RestaurantModel toggleModel(RestaurantModel r) => r.id == restaurantId
        ? RestaurantModel(
            id: r.id,
            name: r.name,
            nameAr: r.nameAr,
            description: r.description,
            descriptionAr: r.descriptionAr,
            image: r.image,
            coverImage: r.coverImage,
            rating: r.rating,
            reviewCount: r.reviewCount,
            deliveryTime: r.deliveryTime,
            deliveryFee: r.deliveryFee,
            minimumOrder: r.minimumOrder,
            isOpen: r.isOpen,
            isActive: r.isActive,
            isFavorite: newFav,
            isTopRated: r.isTopRated,
            address: r.address,
            phone: r.phone,
          )
        : r;

    final updatedTopRated = current.topRatedRestaurants.map(toggleModel).toList();

    List<RestaurantModel> updatedFavorites;
    final existsInFav = current.favoriteRestaurants.any((r) => r.id == restaurantId);
    if (newFav) {
      // ensure it's in favorites
      if (existsInFav) {
        updatedFavorites = current.favoriteRestaurants.map(toggleModel).toList();
      } else {
        // add to the beginning using base with toggled flag
        final added = toggleModel(base);
        updatedFavorites = [added, ...current.favoriteRestaurants];
      }
    } else {
      // remove from favorites
      updatedFavorites = current.favoriteRestaurants
          .where((r) => r.id != restaurantId)
          .toList();
    }

    emit(
      HomeSuccess(
        categories: current.categories,
        offers: current.offers,
        favoriteRestaurants: updatedFavorites,
        topRatedRestaurants: updatedTopRated,
        bestSellingFoods: current.bestSellingFoods,
        favoriteFoods: current.favoriteFoods,
      ),
    );

    final result = await _homeRepo.toggleRestaurantFavorite(restaurantId, lang);
    result.fold(
      (error) {
        // Rollback on error (avoid switching to error screen)
        emit(current);
      },
      (updatedFromServer) async {
        // Reconcile with server response (no full reload)
        final serverFav = updatedFromServer.isFavorite ?? newFav;

        RestaurantModel applyServer(RestaurantModel r) => r.id == restaurantId
            ? RestaurantModel(
                id: updatedFromServer.id,
                name: updatedFromServer.name,
                nameAr: updatedFromServer.nameAr,
                description: updatedFromServer.description,
                descriptionAr: updatedFromServer.descriptionAr,
                image: updatedFromServer.image,
                coverImage: updatedFromServer.coverImage,
                rating: updatedFromServer.rating,
                reviewCount: updatedFromServer.reviewCount,
                deliveryTime: updatedFromServer.deliveryTime,
                deliveryFee: updatedFromServer.deliveryFee,
                minimumOrder: updatedFromServer.minimumOrder,
                isOpen: updatedFromServer.isOpen,
                isActive: updatedFromServer.isActive,
                isFavorite: serverFav,
                isTopRated: updatedFromServer.isTopRated,
                address: updatedFromServer.address,
                phone: updatedFromServer.phone,
              )
            : r;

        final curr = state;
        if (curr is HomeSuccess) {
          final newTop = curr.topRatedRestaurants.map(applyServer).toList();
          List<RestaurantModel> newFavList;
          final inFavNow = curr.favoriteRestaurants.any((r) => r.id == restaurantId);
          if (serverFav) {
            if (inFavNow) {
              newFavList = curr.favoriteRestaurants.map(applyServer).toList();
            } else {
              newFavList = [applyServer(base), ...curr.favoriteRestaurants];
            }
          } else {
            newFavList = curr.favoriteRestaurants.where((r) => r.id != restaurantId).toList();
          }
          emit(
            HomeSuccess(
              categories: curr.categories,
              offers: curr.offers,
              favoriteRestaurants: newFavList,
              topRatedRestaurants: newTop,
              bestSellingFoods: curr.bestSellingFoods,
              favoriteFoods: curr.favoriteFoods,
            ),
          );
        }
      },
    );
  }
}
