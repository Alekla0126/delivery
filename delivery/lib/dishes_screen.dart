import 'package:delivery/cart_service/cart_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dishes_service/dishes_events.dart';
import 'dishes_service/dishes_state.dart';
import 'dishes_service/dishes_bloc.dart';
import 'package:flutter/material.dart';
import 'cart_service/cart_bloc.dart';
import 'dishes_service/dishes.dart';

class DishScreen extends StatefulWidget {
  final String categoryName;

  const DishScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  _DishScreenState createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  DishesBloc? _dishesBloc;
  Set<String> selectedTags = <String>{};
  Dish? selectedDish;

  @override
  void initState() {
    super.initState();
    _dishesBloc = context.read<DishesBloc>();
    _dishesBloc?.add(FetchDishesEvent());
  }

  void showDishDetails(Dish dish) {
    setState(() {
      selectedDish = dish;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedDish != null)
                Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              selectedDish!.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // TODO: Implement like/dislike functionality
                                  },
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${selectedDish!.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '   ${selectedDish!.weight}г',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedDish!.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement Add to Cart functionality
                  context.read<CartBloc>().add(AddDish(dish: selectedDish!));
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        );
      },
    );
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
            List<String> uniqueTags = state.dishes.expand((dish) => dish.tags).toSet().toList();
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
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        mainAxisExtent: 180,
                      ),
                      itemCount: filteredDishes.length,
                      itemBuilder: (context, index) {
                        final dish = filteredDishes[index];
                        return GestureDetector(
                          onTap: () => showDishDetails(dish),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: Card(
                                  color: Colors.grey[200],
                                  child: Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.network(
                                          dish.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 1),
                              SizedBox(
                                width: 100,
                                height: 40,
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
                          ),
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