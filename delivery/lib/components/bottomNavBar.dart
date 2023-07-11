import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '../cart_service/cart_bloc.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (_) => context.read<CartBloc>(),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true, // Show labels for the selected tab
        showUnselectedLabels: true, // Show labels for the unselected tabs
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/главная.svg',
              width: 24,
              height: 24,
              color: currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/поиск.svg',
              width: 24,
              height: 24,
              color: currentIndex == 1 ? Colors.blue : Colors.grey,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/корзина.svg',
              width: 24,
              height: 24,
              color: currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            label: "Shopping Cart",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/аккаунт.svg',
              width: 24,
              height: 24,
              color: currentIndex == 3 ? Colors.blue : Colors.grey,
            ),
            label: "Account",
          ),
        ],
      ),
    );
  }
}