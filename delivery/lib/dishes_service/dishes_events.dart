import 'dishes.dart'; // Import the Dish class

abstract class DishesEvent {}

class FetchDishesEvent extends DishesEvent {}

class ToggleDishLikeEvent extends DishesEvent {
  final Dish dish;

  ToggleDishLikeEvent(this.dish);
}