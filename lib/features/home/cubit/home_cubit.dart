import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/home/data/repos/home_repo.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';
import 'package:deliva_eat/core/network/api_error_handler.dart';

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
        emit(HomeSuccess(
          categories: homeResponse.data.categories,
          offers: homeResponse.data.offers,
          favoriteRestaurants: homeResponse.data.favoriteRestaurants,
          topRatedRestaurants: homeResponse.data.topRatedRestaurants,
          bestSellingFoods: homeResponse.data.bestSellingFoods,
        ));
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
}
