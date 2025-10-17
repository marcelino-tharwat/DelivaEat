import 'package:deliva_eat/features/cart/data/models/cart_response.dart';

abstract class CartState {}

class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartError extends CartState {
  final String message;
  CartError(this.message);
}
class CartLoaded extends CartState {
  final CartData data;
  CartLoaded(this.data);
}
