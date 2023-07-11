import 'dishes.dart'; // Import the Dish class

abstract class DishesState {}

class DishesInitialState extends DishesState {}

class DishesLoadingState extends DishesState {}

class DishesLoadedState extends DishesState {
  final List<Dish> dishes;

  DishesLoadedState({required this.dishes});
}

class DishesErrorState extends DishesState {
  final String error;

  DishesErrorState({required this.error});
}

class DishLikedState extends DishesState {
  final Dish dish;

  DishLikedState({required this.dish});
}