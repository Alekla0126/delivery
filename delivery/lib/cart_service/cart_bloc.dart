import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartLoading());

  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is AddDish) {
      await cartRepository.addDish(event.dish);
    } else if (event is RemoveDish) {
      await cartRepository.removeDish(event.dish);
    }
    final cartItems = await cartRepository.getCart();
    yield CartLoaded(cartItems: cartItems);
  }
}

