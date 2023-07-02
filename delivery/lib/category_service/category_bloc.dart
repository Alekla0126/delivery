import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_repository.dart';
import 'category_provider.dart';
import 'category_events.dart';
import 'category_states.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  final CategoryProvider categoryDataProvider;

  CategoryBloc({
    required this.categoryRepository,
    required this.categoryDataProvider,
  }) : super(CategoryInitialState()) {
    on<FetchCategoriesEvent>((event, emit) async {
      emit(CategoryLoadingState());

      try {
        final categories = await categoryRepository.fetchCategories();
        emit(CategoryLoadedState(categories: categories));
      } catch (e) {
        emit(CategoryErrorState(error: e.toString()));
      }
    });
  }
}