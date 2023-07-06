import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'cart_service/cart_state.dart';
import 'cart_service/cart_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  final CartBloc cartBloc;

  const CheckoutScreen({Key? key, required this.cartBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the cartBloc from the context. Assume you already have CartBloc which handles the state of the cart

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            return ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = state.cartItems[index];
                return ListTile(
                  leading: Image.network(cartItem.dish.imageUrl),
                  title: Text(cartItem.dish.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Text('\$${cartItem.dish.price.toString()}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      Text(' ${cartItem.dish.weight}g', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  trailing: Text('x${cartItem.quantity}'), // Now we have the quantity attribute in our CartItem
                );
              },
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  // Implement your purchase logic here
                },
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final total = (state is CartLoaded)
                        ? state.cartItems.fold(
                      0,
                          (previousValue, cartItem) =>
                      previousValue + cartItem.dish.price * cartItem.quantity,
                    )
                        : 0;
                    return Text('Purchase \$${total.toString()}');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}