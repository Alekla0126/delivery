import 'package:flutter_bloc/flutter_bloc.dart';
import 'dishes_service/dishes_events.dart';
import 'dishes_service/dishes_state.dart';
import 'dishes_service/dishes_bloc.dart';
import 'package:flutter/material.dart';
import 'dishes_service/dishes.dart';

class DishScreen extends StatefulWidget {
  final String categoryName;

  const DishScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  _DishScreenState createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  DishesBloc? _dishesBloc;

  // Create a Set to keep track of selected tags
  Set<String> selectedTags = <String>{};

  @override
  void initState() {
    super.initState();
    _dishesBloc = context.read<DishesBloc>();
    _dishesBloc?.add(FetchDishesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.categoryName, style: const TextStyle(color: Colors.black)),
        leading: const BackButton(color: Colors.black),
        actions: const <Widget>[
          CircleAvatar(
            backgroundColor: Colors.blue,
            // Add image inside the CircleAvatar here
            // backgroundImage: NetworkImage('url_of_the_image'),
          ),
        ],
      ),
      body: BlocBuilder<DishesBloc, DishesState>(
        builder: (context, state) {
          if (state is DishesInitialState || state is DishesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DishesLoadedState) {
            // Get a list of unique tags from the dishes
            List<String> uniqueTags = state.dishes.expand((dish) => dish.tags).toSet().toList();

            // Filter dishes based on selected tags
            List<Dish> filteredDishes = state.dishes.where((dish) =>
            dish.tags.any((tag) => selectedTags.contains(tag)) || selectedTags.isEmpty
            ).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: uniqueTags.length,
                      itemBuilder: (context, index) {
                        final tag = uniqueTags[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedTags.contains(tag)) {
                                selectedTags.remove(tag);
                              } else {
                                selectedTags.add(tag);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: selectedTags.contains(tag) ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(child: Text(tag, style: const TextStyle(color: Colors.white))),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // number of columns
                        childAspectRatio: 1, // ratio between width and height of items
                        mainAxisExtent: 180,
                      ),
                      itemCount: filteredDishes.length,
                      itemBuilder: (context, index) {
                        final dish = filteredDishes[index];
                        return Column(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Card(
                                color: Colors.grey[200],
                                child: AspectRatio(
                                  aspectRatio: 1, // Adjust the aspect ratio to your desired value
                                  child: OverflowBox(
                                    maxWidth: 120,
                                    maxHeight: 120,
                                    child: Image.network(
                                      dish.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 1),
                            SizedBox(
                              width: 100,
                              height: 40, // Adjust the height as per your needs
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      dish.name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );

          } else if (state is DishesErrorState) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}