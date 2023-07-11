import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class BottomNavBarEvent {}

class ChangeNavBarIndex extends BottomNavBarEvent {
  final int index;
  ChangeNavBarIndex(this.index);
}

class ShowDishesScreen extends BottomNavBarEvent {
  final String category;
  ShowDishesScreen(this.category);
}

class SelectCategory extends BottomNavBarEvent {
  final String category;

  SelectCategory(this.category);
}

// State
class NavBarState {
  final int index;
  final bool showDishesScreen;
  final String selectedCategory;
  NavBarState(this.index, {this.showDishesScreen = false, required this.selectedCategory});
}

// Bloc
class BottomNavBarBloc extends Bloc<BottomNavBarEvent, NavBarState> {
  BottomNavBarBloc() : super(NavBarState(0, selectedCategory: '')) {
    on<ChangeNavBarIndex>((event, emit) {
      emit(NavBarState(event.index, showDishesScreen: false, selectedCategory: state.selectedCategory));
    });

    on<ShowDishesScreen>((event, emit) {
      emit(NavBarState(state.index, showDishesScreen: true, selectedCategory: event.category));
    });

    on<SelectCategory>((event, emit) {
      emit(NavBarState(state.index, selectedCategory: event.category));
    });
  }
}