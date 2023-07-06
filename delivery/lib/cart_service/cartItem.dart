import '../dishes_service/dishes.dart';

class CartItem {
  final Dish dish;
  int quantity;

  CartItem({
    required this.dish,
    required this.quantity,
  });
}