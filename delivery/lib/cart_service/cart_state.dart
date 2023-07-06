import 'cartItem.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded({required this.cartItems}) : super();

  List<Object> get props => [cartItems];
}

class CartError extends CartState {
  final String error;

  CartError({required this.error});
}