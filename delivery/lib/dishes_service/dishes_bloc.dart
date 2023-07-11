import 'package:flutter_bloc/flutter_bloc.dart';
import 'dishes.dart';
import 'dishes_repository.dart'; // Update this import as per your project structure
import 'dishes_events.dart'; // Update this import as per your project structure
import 'dishes_state.dart'; // Update this import as per your project structure

class DishesBloc extends Bloc<DishesEvent, DishesState> {
  final DishesRepository dishesRepository;

  DishesBloc({required this.dishesRepository}) : super(DishesInitialState()) {
    on<FetchDishesEvent>((event, emit) async {
      emit(DishesLoadingState());
      try {
        final dishes = await dishesRepository.fetchDishes();
        emit(DishesLoadedState(dishes: dishes));
      } catch (e) {
        emit(DishesErrorState(error: e.toString()));
      }
    });

    on<ToggleDishLikeEvent>((event, emit) {
      if (state is DishesLoadedState) {
        final List<Dish> updatedDishes = List.from((state as DishesLoadedState).dishes);
        final int dishIndex = updatedDishes.indexWhere((dish) => dish.id == event.dish);
        if (dishIndex != -1) {
          final Dish updatedDish = updatedDishes[dishIndex].copyWith(liked: !updatedDishes[dishIndex].liked);
          updatedDishes[dishIndex] = updatedDish;
          emit(DishesLoadedState(dishes: updatedDishes));
        }
      }
    });
  }
}
