import 'package:delivery/category_service/category_provider.dart';
import 'package:delivery/category_service/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class DeliveryEvent {}

class FetchCategoriesEvent extends DeliveryEvent {}

// States
abstract class DeliveryState {}

class DeliveryInitialState extends DeliveryState {}

class DeliveryLoadingState extends DeliveryState {}

class DeliveryLoadedState extends DeliveryState {
  final List<Category> categories;
  DeliveryLoadedState({required this.categories});
}

class DeliveryErrorState extends DeliveryState {
  final String error;
  DeliveryErrorState({required this.error});
}

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final CategoryDataProvider categoryDataProvider;

  DeliveryBloc({required this.categoryDataProvider}) : super(DeliveryInitialState()) {
    on<FetchCategoriesEvent>((event, emit) async {
      emit(DeliveryLoadingState());

      try {
        final categories = await categoryDataProvider.fetchCategories();
        emit(DeliveryLoadedState(categories: categories));
      } catch (e) {
        emit(DeliveryErrorState(error: e.toString()));
      }
    });
  }
}