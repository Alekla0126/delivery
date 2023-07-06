import '../dishes_service/dishes.dart';
import 'cartItem.dart';

class CartDataProvider {
  final List<CartItem> _cartItems = [];

  void addDish(Dish dish) {
    final existingCartItem = _cartItems.firstWhere(
          (item) => item.dish.id == dish.id,
      orElse: () => CartItem(dish: dish, quantity: -1),
    );
    if (existingCartItem.quantity == -1) {
      _cartItems.add(CartItem(dish: dish, quantity: 1));
    } else {
      existingCartItem.quantity++;
    }
  }

  void removeDish(Dish dish) {
    final existingCartItem = _cartItems.firstWhere(
          (item) => item.dish.id == dish.id,
      orElse: () => CartItem(dish: dish, quantity: -1),
    );
    if (existingCartItem.quantity > 1) {
      existingCartItem.quantity--;
    } else if (existingCartItem.quantity == 1) {
      _cartItems.remove(existingCartItem);
    }
  }

  List<CartItem> getCart() {
    return _cartItems;
  }
}