import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/cart/data/repos/cart_repo.dart';
import 'package:deliva_eat/features/cart/cubit/cart_state.dart';
import 'package:deliva_eat/core/auth/auth_manager.dart';
import 'package:deliva_eat/features/cart/data/local/cart_manager.dart';
import 'package:deliva_eat/features/cart/ui/widgets/cart_item_card.dart';
import 'package:deliva_eat/features/cart/data/models/cart_response.dart';
import 'package:deliva_eat/features/restaurant/data/models/cart_models.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo _repo;
  CartCubit({required CartRepo repo}) : _repo = repo, super(CartInitial());

  Future<void> loadCart({String lang = 'ar'}) async {
    emit(CartLoading());
    final isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      // Load from backend
      final res = await _repo.getCart(lang);
      res.either(
        (err) => emit(CartError(err.errorMessage)),
        (data) => emit(CartLoaded(data)),
      );
    } else {
      // Load from local storage
      final localItems = await CartManager.loadCart();
      // For guest mode, we need to create a CartData with empty items since UI expects CartData
      // But we will handle local items separately in the UI
      final cartData = CartData(ownerKey: '', items: []);
      emit(CartLoaded(cartData));
    }
  }

  Future<void> incrementItem(String id, int currentQty, {String lang = 'ar'}) async {
    final isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      final res = await _repo.updateQuantity(id: id, quantity: currentQty + 1);
      res.either(
        (err) => emit(CartError(err.errorMessage)),
        (_) => loadCart(lang: lang),
      );
    } else {
      await CartManager.updateQuantity(id, currentQty + 1);
      loadCart(lang: lang);
    }
  }

  Future<void> decrementItem(String id, int currentQty, {String lang = 'ar'}) async {
    if (currentQty <= 1) return; // avoid going below 1
    final isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      final res = await _repo.updateQuantity(id: id, quantity: currentQty - 1);
      res.either(
        (err) => emit(CartError(err.errorMessage)),
        (_) => loadCart(lang: lang),
      );
    } else {
      await CartManager.updateQuantity(id, currentQty - 1);
      loadCart(lang: lang);
    }
  }

  Future<void> removeItem(String id, {String lang = 'ar'}) async {
    final isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      final res = await _repo.removeItem(id: id);
      res.either(
        (err) => emit(CartError(err.errorMessage)),
        (_) => loadCart(lang: lang),
      );
    } else {
      await CartManager.removeItem(id);
      loadCart(lang: lang);
    }
  }

  Future<void> syncLocalCartToBackend() async {
    // After login, sync local cart to backend
    final localItems = await CartManager.loadCart();
    // Implement sync logic here, e.g., add items to backend
    // For now, clear local cart after sync
    await CartManager.clearCart();
  }
}
