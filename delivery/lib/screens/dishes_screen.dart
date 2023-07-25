import 'package:delivery/cart_service/cart_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dishes_service/dishes_events.dart';
import '../dishes_service/dishes_state.dart';
import '../dishes_service/dishes_bloc.dart';
import 'package:flutter/material.dart';
import '../cart_service/cart_bloc.dart';
import '../dishes_service/dishes.dart';

class DishScreen extends StatefulWidget {
  final VoidCallback goBackToHome;
  final String categoryName;
  int currentIndex; // New parameter

  DishScreen({
    Key? key,
    required this.categoryName,
    required this.currentIndex,
    required this.goBackToHome,
  }) : super(key: key);

  @override
  _DishScreenState createState() => _DishScreenState();
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

class _DishScreenState extends State<DishScreen> {
  Set<String> selectedTags = <String>{};
  DishesBloc? _dishesBloc;
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
          content: SingleChildScrollView(
            child: Column(
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
                            Flexible(
                              child: Image.network(
                                selectedDish!.imageUrl,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Row(
                                children: [
                                  Card(
                                    child: IconButton(
                                      onPressed: () {
                                        _toggleLiked(selectedDish!);
                                      },
                                      icon: Icon(
                                        selectedDish!.liked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Card(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      final cartBloc = context.read<CartBloc>();
                      cartBloc.add(AddDish(dish: selectedDish!));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorFromHex('3364E0'),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleLiked(Dish dish) {
    _dishesBloc?.add(ToggleDishLikeEvent(dish));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<DishesBloc, DishesState>(
                builder: (context, state) {
                  if (state is DishesInitialState || state is DishesLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DishesLoadedState) {
                    List<String> uniqueTags =
                    state.dishes.expand((dish) => dish.tags).toSet().toList();
                    List<Dish> filteredDishes = state.dishes
                        .where((dish) =>
                    dish.tags.any((tag) => selectedTags.contains(tag)) ||
                        selectedTags.isEmpty)
                        .toList();
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          height: 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            children: _buildFilterTags(uniqueTags),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.8,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              itemCount: filteredDishes.length,
                              itemBuilder: (context, index) {
                                final dish = filteredDishes[index];
                                return GestureDetector(
                                  onTap: () => showDishDetails(dish),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          color: Colors.grey[200],
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                              dish.imageUrl,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 100,
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              dish.name,
                                              textAlign: TextAlign.center,
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
            ),
          ],
        ), // use the passed navBar here
      ),
    );
  }

  List<Widget> _buildFilterTags(List<String> uniqueTags) {
    return uniqueTags.map((tag) {
      final isSelected = selectedTags.contains(tag);
      final color = isSelected ? Colors.blue : Colors.grey;
      return GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedTags.remove(tag);
            } else {
              selectedTags.add(tag);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            tag,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }).toList();
  }
}