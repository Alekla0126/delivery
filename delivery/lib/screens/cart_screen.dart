import 'package:delivery/cart_service/cart_state.dart';
import 'package:delivery/cart_service/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart_service/cart_event.dart';
import 'package:flutter/material.dart';
import '../dishes_service/dishes.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key, required int currentIndex}) : super(key: key);

  void decrementQuantity(BuildContext context, Dish dish) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(DecrementQuantity(dish: dish));
  }

  void incrementQuantity(BuildContext context, Dish dish) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(IncrementQuantity(dish: dish));
  }

  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context); // Retrieve the CartBloc instance

    return Scaffold(
      body: BlocBuilder<CartBloc, CartState>(
        bloc: cartBloc,
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Your cart is empty')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Purchase \$0'),
                  ),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: state.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = state.cartItems[index];
                  return ListTile(
                    leading: Image.network(cartItem.dish.imageUrl),
                    title: Text(
                      cartItem.dish.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          '\$${cartItem.dish.price.toString()}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${cartItem.dish.weight}g',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            decrementQuantity(context, cartItem.dish); // Dispatch the DecrementQuantity event
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text('${cartItem.quantity}'),
                        IconButton(
                          onPressed: () {
                            incrementQuantity(context, cartItem.dish); // Dispatch the IncrementQuantity event
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          } else if (state is CartInitial) {
            return const Center(child: Text('Cart not loaded yet'));
          } else if (state is CartError) {
            return const Center(child: Text('An error occurred'));
          } else {
            print("The state is:");
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        bloc: cartBloc, // Provide bloc here
        builder: (context, state) {
          if (state is CartLoaded && state.cartItems.isNotEmpty) {
            final total = state.cartItems.fold(
              0,
                  (previousValue, cartItem) =>
              previousValue + cartItem.dish.price * cartItem.quantity,
            );
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  // Implement your purchase logic here
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: colorFromHex('3364E0'),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                child: Text('Purchase \$${total.toString()}'),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}