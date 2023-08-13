import 'package:delivery/cart_service/cart_repository.dart';
import 'package:delivery/cart_service/cart_event.dart';
import 'package:delivery/cart_service/cart_state.dart';
import 'package:delivery/cart_service/cartItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartLoading()) {
    on<AddDish>((event, emit) async {
      print("Event received: $event");
      await cartRepository.addDish(event.dish);
      final cartItems = await cartRepository.getCart();
      print("Cart items: $cartItems");
      emit(CartLoaded(cartItems: cartItems));
    });
    on<RemoveDish>((event, emit) async {
      await cartRepository.removeDish(event.dish);
      final cartItems = await cartRepository.getCart();
      emit(CartLoaded(cartItems: cartItems));
    });
    on<DecrementQuantity>((event, emit) async {
      final cartItems = await cartRepository.getCart();
      final updatedCartItems = cartItems.map((cartItem) {
        if (cartItem.dish == event.dish) {
          final updatedQuantity = cartItem.quantity - 1;
          if (updatedQuantity > 0) {
            return CartItem(dish: cartItem.dish, quantity: updatedQuantity);
          } else {
            return null; // Return null to remove the item from the list
          }
        } else {
          return cartItem;
        }
      }).whereType<CartItem>().toList();
      await cartRepository.updateCart(updatedCartItems);
      emit(CartLoaded(cartItems: updatedCartItems));
    });
    on<IncrementQuantity>((event, emit) async {
      final cartItems = await cartRepository.getCart();
      final updatedCartItems = cartItems.map((cartItem) {
        if (cartItem.dish == event.dish) {
          final updatedQuantity = cartItem.quantity + 1;
          return CartItem(dish: cartItem.dish, quantity: updatedQuantity);
        } else {
          return cartItem;
        }
      }).toList();
      await cartRepository.updateCart(updatedCartItems);
      emit(CartLoaded(cartItems: updatedCartItems));
    });
  }
}