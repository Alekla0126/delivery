import 'category_service/category_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dishes_service/dishes_repository.dart';
import 'category_service/delivery_bloc.dart';
import 'package:delivery/dishes_screen.dart';
import 'dishes_service/dishes_bloc.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  static const TextStyle _categoryTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeliveryBloc>(
      create: (context) =>
          DeliveryBloc(categoryDataProvider: CategoryDataProvider()),
      child: BlocConsumer<DeliveryBloc, DeliveryState>(
        listener: (context, state) {
          if (state is DeliveryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is DeliveryInitialState) {
            BlocProvider.of<DeliveryBloc>(context).add(FetchCategoriesEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is DeliveryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DeliveryLoadedState) {
            return Center(
              child: SizedBox(
                width: 400.0, // Set the maximum width of the cards
                child: ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider<DishesBloc>(
                              create: (_) => DishesBloc(
                                  dishesRepository: DishesRepository()),
                              child: DishScreen(categoryName: category.name),
                            ),
                          ),
                        );
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
                                fit: BoxFit.cover,
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
