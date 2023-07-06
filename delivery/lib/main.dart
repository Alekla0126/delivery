import 'package:delivery/cart_service/cart_provider.dart';
import 'package:delivery/cart_service/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delivery/cart_screen.dart';
import 'package:flutter/material.dart';
import 'cart_service/cart_bloc.dart';
import 'package:intl/intl.dart';
import 'category_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DeliveryHome(),
    );
  }
}

class DeliveryHome extends StatefulWidget {
  const DeliveryHome({super.key});
  @override
  _DeliveryHomeState createState() => _DeliveryHomeState();
}

class _DeliveryHomeState extends State<DeliveryHome> {
  late final CartDataProvider cartDataProvider;
  late final CartRepository cartRepository;
  late final CartBloc cartBloc;
  int _currentIndex = 0;
  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    cartDataProvider = CartDataProvider();
    cartRepository = CartRepository(cartDataProvider: cartDataProvider);
    cartBloc = CartBloc(cartRepository: cartRepository);
    _children = [
      const HomeScreen(),
      Container(),
      CheckoutScreen(cartBloc: cartBloc),
      Container()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat.yMMMMd().format(DateTime.now()); // Get current date

    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (_) => cartBloc,
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const Icon(Icons.location_on, color: Colors.black),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Location",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentDate, // Display current date
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(),
              ],
            ),
          ),
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              // If it's not the first or third item, then do nothing
              if (index != 0 && index != 2) {
                return;
              }
              // Otherwise, update the state
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: "Shopping Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

