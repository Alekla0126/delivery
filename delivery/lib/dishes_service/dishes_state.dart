import 'dishes.dart'; // Update this import as per your project structure

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