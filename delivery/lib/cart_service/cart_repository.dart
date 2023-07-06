import '../dishes_service/dishes.dart';
import 'cart_provider.dart';
import 'cartItem.dart';

class CartRepository {
  final CartDataProvider cartDataProvider;

  CartRepository({required this.cartDataProvider});

  Future<void> addDish(Dish dish) async {
    cartDataProvider.addDish(dish);
  }

  Future<void> removeDish(Dish dish) async {
    cartDataProvider.removeDish(dish);
  }

  Future<List<CartItem>> getCart() {
    return Future.value(cartDataProvider.getCart());
  }
}
