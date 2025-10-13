import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/restaurant/cubit/product_state.dart';
import 'package:deliva_eat/features/restaurant/data/repos/product_repo.dart';
import 'package:deliva_eat/features/restaurant/data/models/cart_models.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo _repo;
  ProductCubit({required ProductRepo repo}) : _repo = repo, super(ProductInitial());

  Future<void> addToCart({
    required String foodId,
    int quantity = 1,
    List<CartOption> options = const [],
    String lang = 'ar',
  }) async {
    emit(ProductAdding());
    final res = await _repo.addToCart(
      foodId: foodId,
      quantity: quantity,
      options: options,
      lang: lang,
    );
    res.either(
      (err) => emit(ProductError(err.errorMessage)),
      (item) => emit(ProductAdded(item)),
    );
  }
}
