import 'package:delivery/cart_service/cart_repository.dart';
import 'package:delivery/cart_service/cart_provider.dart';
import 'package:delivery/screens/cart_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dishes_service/dishes_repository.dart';
import 'buttom_nav_bar/buttom_nav_bar.dart';
import 'dishes_service/dishes_bloc.dart';
import 'package:flutter/material.dart';
import 'components/bottomNavBar.dart';
import 'screens/category_screen.dart';
import 'cart_service/cart_bloc.dart';
import 'screens/dishes_screen.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final cartDataProvider = CartDataProvider();
    final cartRepository = CartRepository(cartDataProvider: cartDataProvider);
    final cartBloc = CartBloc(cartRepository: cartRepository);
    final dishesBloc = DishesBloc(dishesRepository: DishesRepository());

    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (_) => cartBloc),
        BlocProvider<DishesBloc>(create: (_) => dishesBloc),
        BlocProvider<BottomNavBarBloc>(
          create: (_) => BottomNavBarBloc(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Delivery App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DeliveryHome(),
      ),
    );
  }
}

class DeliveryHome extends StatefulWidget {
  DeliveryHome({Key? key}) : super(key: key);

  @override
  _DeliveryHomeState createState() => _DeliveryHomeState();
}

class _DeliveryHomeState extends State<DeliveryHome> {
  String selectedCategory = '';

  void _goBackToHome() {
    setState(() {
      selectedCategory = '';
    });
    BlocProvider.of<BottomNavBarBloc>(context).add(ChangeNavBarIndex(0));
  }

  AppBar buildAppBar(NavBarState state) {
    final currentDate = DateFormat.yMMMMd().format(DateTime.now());

    if (state.showDishesScreen) {
      return AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: _goBackToHome,
        ),
        title: Text(
          state.selectedCategory ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true, // Center the title within the AppBar
        actions: const [
          CircleAvatar(),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
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
                  currentDate,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const CircleAvatar(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<BottomNavBarBloc, NavBarState>(
          builder: (context, state) {
            return buildAppBar(state);
          },
        ),
      ),
      body: BlocBuilder<BottomNavBarBloc, NavBarState>(
        builder: (context, state) {
          if (state.showDishesScreen) {
            return DishScreen(
              categoryName: state.selectedCategory ?? '',
              currentIndex: state.index,
              goBackToHome: _goBackToHome,
            );
          }
          switch (state.index) {
            case 0:
              return HomeScreen(
                currentIndex: state.index,
                onSelectCategory: (category) =>
                    BlocProvider.of<BottomNavBarBloc>(context).add(ShowDishesScreen(category)),
              );
            case 1:
              return const Placeholder();
            case 2:
              return CheckoutScreen(currentIndex: state.index);
            default:
              return const Placeholder();
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBarBloc, NavBarState>(
        builder: (context, state) {
          return BottomNavBar(
            currentIndex: state.index,
            onTap: (int index) {
              BlocProvider.of<BottomNavBarBloc>(context).add(ChangeNavBarIndex(index));
            },
          );
        },
      ),
    );
  }
}