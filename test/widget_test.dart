// This is a basic Flutter widget test.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/main.dart';

void main() {
  testWidgets('It should test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider<CartState>.value(
      value: CartState(),
      child: MyCartApp(),
    ));
  });

  testWidgets('List of items widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider<CartState>.value(
      value: CartState(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ListOfCartItems(),
      ),
    ));
  });

  testWidgets('Cart Controls test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider<CartState>.value(
      value: CartState(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CartControls(),
      ),
    ));
  });

  testWidgets('Summary test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider<CartState>.value(
      value: CartState(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CartSummary(),
      ),
    ));
  });
}
