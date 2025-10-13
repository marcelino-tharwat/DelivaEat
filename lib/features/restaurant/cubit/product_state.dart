import 'package:deliva_eat/features/restaurant/data/models/cart_models.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductAdding extends ProductState {}

class ProductAdded extends ProductState {
  final CartItemModel item;
  ProductAdded(this.item);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
