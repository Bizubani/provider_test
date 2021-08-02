import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/widgets/item_card.dart';

/// Represenst a Cart Item. Has <int>`id`, <String>`name`, <int>`quantity`
class CartItem {
  final int _id;
  final String _name;
  int _quantity;
  ///Cap on the amount of a single item you can purchase. Maybe this should
  ///differ on a per item basis.
  final int _maxAllowable = 20;

  int get quantity => _quantity;
  String get name => _name;
  int get id => _id;

  /// Allow an item to update it's quantity. It will receive a delta which could
  /// be positive or negative. If the delta reduces [quantity] below 0, set
  /// [quantity] to 0
  int updateQuantity(int delta) {
    // Cart will finish in a legitmate state. No negative quantity
    _quantity += delta;
    if (_quantity < 0) _quantity = 0;
    if (_quantity > _maxAllowable) _quantity = _maxAllowable;
    return _quantity;
  }

  CartItem(this._id, this._name, this._quantity);
}

/// Manages a cart. Implements ChangeNotifier
class CartState with ChangeNotifier {
  /// Use a map instead of a list for faster lookups. Since the id should be
  /// unique, it makes a fantastic key
  Map<int, CartItem> _productMap = {};
  int _totalCartItems = 0;

  CartState();

  /// The number of individual items in the cart. That is, all cart items' quantities.
  int get totalCartItems => _totalCartItems; //return actual cart volume.

  /// The list of CartItems in the cart
  List<CartItem> get products => _productMap.values.toList();

  /// Clears the cart. Notifies any consumers.
  void clearCart() {
    //Set the cart to it's initial state
    _productMap = {};
    _totalCartItems = 0;
    notifyListeners();
  }

  /// Adds a new CartItem to the cart. Notifies any consumers.
  void addToCart({required CartItem item}) {
    //Do not assume the item is not already in the cart, check.
    if (_productMap.containsKey(item.id)) {
      updateQuantity(id: item.id, newQty: item.quantity);
      return;
    }
    _productMap[item.id] = item;
    _totalCartItems += item.quantity;
    notifyListeners();
  }

  /// Updates the quantity of the Cart item with this id. Notifies any consumers.
  void updateQuantity({required int id, required int newQty}) {
    if (_productMap.containsKey(id)) {
      //The item should not be null
      CartItem item = _productMap[id]!;
      //Minus all the items of this type from the cart.
      _totalCartItems -= item.quantity;

      ///Then modify the quantity. This will always end in a valid state as it
      /// can never go lower than zero.
      if (item.updateQuantity(newQty) == 0) {
        //If after updating the quantity there are zero in the cart, remove it
        _productMap.remove(id);
      } else {
        //Add back the new quantity to the total items
        _totalCartItems += item.quantity;
      }
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartState(),
      child: MyCartApp(),
    ),
  );
}

class MyCartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shopping Cart Demo",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.pinkAccent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            headline2: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            bodyText1: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
            button: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colors.purpleAccent)),
      ),
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              ListOfCartItems(),
              CartSummary(),
              CartControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class CartControls extends StatelessWidget {
  /// Handler for Add Item pressed
  void _addItemPressed(BuildContext context) {
    /// mostly unique cartItemId.
    /// don't change this; not important for this test
    int nextCartItemId = Random().nextInt(10000);
    String nextCartItemName = 'A cart item';
    int nextCartItemQuantity = 1;

    CartItem item = new CartItem(nextCartItemId, nextCartItemName,
        nextCartItemQuantity); // Actually use the CartItem constructor to assign id, name and quantity

    CartState _currentState = context.read<CartState>();
    _currentState.addToCart(item: item);
  }

  /// Handle clear cart pressed. Should clear the cart
  void _clearCartPressed(BuildContext context) {
    CartState _currentState = context.read<CartState>();
    _currentState.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final Widget addCartItemWidget = TextButton(
      child: Text(
        'Add Item',
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: () {
        _addItemPressed(context);
      },
    );

    final Widget clearCartWidget = TextButton(
      child: Text(
        'Clear Cart',
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: () {
        _clearCartPressed(context);
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        addCartItemWidget,
        clearCartWidget,
      ],
    );
  }
}

class ListOfCartItems extends StatelessWidget {
  /// Handles adding 1 to the current cart item quantity.
  void _incrementQuantity(BuildContext context, int id, int delta) {
    CartState _currentState = context.read<CartState>();
    _currentState.updateQuantity(id: id, newQty: delta);
  }

  /// Handles removing 1 to the current cart item quantity.
  void _decrementQuantity(BuildContext context, int id, int delta) {
    CartState _currentState = context.read<CartState>();
    _currentState.updateQuantity(id: id, newQty: delta);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<CartState>(
            builder: (BuildContext context, CartState cart, Widget? child) {
          if (cart.totalCartItems == 0) {
            return Text(
              "The cart is currently empty. Add an item!",
              style: Theme.of(context).textTheme.headline1,
            );
          }

          return Column(
            children: cart.products
                .map((c) => ItemCard(
                    increment: _incrementQuantity,
                    decrement: _decrementQuantity,
                    item: c))
                .toList(),
          );
        }));
  }
}

class CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartState>(
      builder: (BuildContext context, CartState cart, Widget? child) {
        return Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0))),
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Total items: ${cart.totalCartItems}",
                    style: Theme.of(context).textTheme.headline2,
                  )),
            ));
      },
    );
  }
}
