// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:delivery/dishes_service/dishes_repository.dart';
import 'package:delivery/cart_service/cart_repository.dart';
import 'package:delivery/dishes_service/dishes_bloc.dart';
import 'package:delivery/cart_service/cart_provider.dart';
import 'package:delivery/cart_service/cart_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:delivery/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final cartDataProvider = CartDataProvider();
    final cartRepository = CartRepository(cartDataProvider: cartDataProvider);
    final cartBloc = CartBloc(cartRepository: cartRepository);
    final dishesBloc = DishesBloc(dishesRepository: DishesRepository());

    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
