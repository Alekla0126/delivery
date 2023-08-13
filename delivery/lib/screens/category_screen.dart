import 'package:delivery/category_service/category_provider.dart';
import '../category_service/category_repository.dart';
import '../category_service/category_states.dart';
import '../category_service/category_events.dart';
import '../category_service/category_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  int currentIndex;
  final void Function(String) onSelectCategory;

  HomeScreen({
    Key? key,
    required this.currentIndex,
    required this.onSelectCategory,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Access the currentIndex using widget.currentIndex

  static const TextStyle _categoryTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final categoryProvider = CategoryProvider(); // Create an instance of CategoryProvider

    return BlocProvider<CategoryBloc>(
        create: (context) => CategoryBloc(
      categoryRepository: CategoryRepository(
        categoryDataProvider: categoryProvider,
      ),
      categoryDataProvider: categoryProvider,
    ),
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryInitialState) {
            BlocProvider.of<CategoryBloc>(context).add(FetchCategoriesEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoadedState) {
            return Center(
              child: SizedBox(
                width: 400.0, // Set the maximum width of the cards
                child: ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return GestureDetector(
                      onTap: () {
                        // Here, we use the onSelectCategory function instead of Navigator.push
                        widget.onSelectCategory(category.name);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                category.imageUrl,
                                fit: BoxFit.fill,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return CircularProgressIndicator(
                                    color: Colors.red,
                                    value:
                                        loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              left: 8.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category.name,
                                  style: _categoryTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            // If somehow none of the above states match
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
