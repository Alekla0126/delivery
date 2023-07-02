import 'package:flutter_bloc/flutter_bloc.dart';
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
  }
}
