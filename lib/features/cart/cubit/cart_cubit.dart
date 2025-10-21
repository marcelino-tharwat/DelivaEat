import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/cart/data/repos/cart_repo.dart';
import 'package:deliva_eat/features/cart/cubit/cart_state.dart';
import 'package:deliva_eat/features/cart/data/models/cart_response.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _repo;
  CartCubit({required CartRepo repo}) : _repo = repo, super(CartInitial());

  Future<void> loadCart({String lang = 'ar'}) async {
    emit(CartLoading());
    // Always load from backend (guest carts are supported via x-cart-key header)
    final res = await _repo.getCart(lang);
    res.either(
      (err) => emit(CartError(err.errorMessage)),
      (data) => emit(CartLoaded(data)),
    );
  }

  Future<void> incrementItem(String id, int currentQty, {String lang = 'ar'}) async {
    final res = await _repo.updateQuantity(id: id, quantity: currentQty + 1);
    res.either(
      (err) => emit(CartError(err.errorMessage)),
      (_) => loadCart(lang: lang),
    );
  }

  Future<void> decrementItem(String id, int currentQty, {String lang = 'ar'}) async {
    if (currentQty <= 1) return; // avoid going below 1
    final res = await _repo.updateQuantity(id: id, quantity: currentQty - 1);
    res.either(
      (err) => emit(CartError(err.errorMessage)),
      (_) => loadCart(lang: lang),
    );
  }

  Future<void> removeItem(String id, {String lang = 'ar'}) async {
    final res = await _repo.removeItem(id: id);
    res.either(
      (err) => emit(CartError(err.errorMessage)),
      (_) => loadCart(lang: lang),
    );
  }

  Future<void> syncLocalCartToBackend() async {
    // No-op: backend cart is used for guest and logged-in via headers.
  }
}
