import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/restaurant/cubit/restaurant_state.dart';
import 'package:deliva_eat/features/restaurant/data/repos/restaurant_repo.dart';
import 'package:deliva_eat/features/restaurant/data/models/restaurant_details_model.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final RestaurantRepo _repo;
  final String restaurantId;
  final String lang;

  RestaurantDetailsData? _details;
  final Map<String, List<FoodModel>> _itemsByTab = {};
  final Set<String> _loadingTabs = {};

  RestaurantCubit({required RestaurantRepo repo, required this.restaurantId, this.lang = 'ar'})
      : _repo = repo,
        super(RestaurantInitial());

  Future<void> loadDetails() async {
    emit(RestaurantLoading());
    final res = await _repo.getRestaurantDetails(restaurantId: restaurantId, lang: lang);
    res.either(
      (err) => emit(RestaurantError(err.errorMessage)),
      (details) {
        _details = details;
        emit(RestaurantLoaded(
          details: details,
          itemsByTab: Map.from(_itemsByTab),
          loadingTabs: Set.from(_loadingTabs),
          isFavorite: details.restaurant.isFavorite ?? false,
        ));
      },
    );
  }

  Future<void> loadTab(String tab) async {
    if (_details == null) return;
    if (_loadingTabs.contains(tab)) return;
    _loadingTabs.add(tab);
    _emitLoaded();

    final res = await _repo.getFoodsByRestaurant(
      restaurantId: restaurantId,
      limit: 50,
      lang: lang,
      tab: tab,
      type: _details?.type,
    );
    res.either(
      (_) {
        _itemsByTab[tab] = [];
        _loadingTabs.remove(tab);
        _emitLoaded();
      },
      (foods) {
        _itemsByTab[tab] = foods;
        _loadingTabs.remove(tab);
        _emitLoaded();
      },
    );
  }

  Future<void> toggleFavorite() async {
    final current = state;
    if (_details == null || current is! RestaurantLoaded) return;
    final newVal = !current.isFavorite;
    emit(current.copyWith(isFavorite: newVal));
    final res = await _repo.toggleFavorite(restaurantId: restaurantId, lang: lang);
    res.either(
      (_) => _emitLoaded(forceFavorite: !newVal),
      (ok) {
        if (!ok) {
          _emitLoaded(forceFavorite: !newVal);
        } else {
          _emitLoaded(forceFavorite: newVal);
        }
      },
    );
  }

  void _emitLoaded({bool? forceFavorite}) {
    if (_details == null) return;
    final current = state;
    final fav = forceFavorite ?? (current is RestaurantLoaded ? current.isFavorite : (_details!.restaurant.isFavorite ?? false));
    emit(RestaurantLoaded(
      details: _details!,
      itemsByTab: Map.from(_itemsByTab),
      loadingTabs: Set.from(_loadingTabs),
      isFavorite: fav,
    ));
  }
}
