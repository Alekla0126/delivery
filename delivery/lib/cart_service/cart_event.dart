import '../dishes_service/dishes.dart';

abstract class CartEvent {}

class AddDish extends CartEvent {
  final Dish dish;

  AddDish({required this.dish});
}

class RemoveDish extends CartEvent {
  final Dish dish;

  RemoveDish({required this.dish});
}

class DecrementQuantity extends CartEvent {
  final Dish dish;

  DecrementQuantity({required this.dish});
}

class IncrementQuantity extends CartEvent {
  final Dish dish;

  IncrementQuantity({required this.dish});
}