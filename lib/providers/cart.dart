import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  void addItem(String productId, double price, String title) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existingItem) => CartItem(
          id: DateTime.now().toString(),
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  int get itemCount {
    var count = 0;
    _cartItems.forEach((key, value) {
      count += value.quantity;
    });

    return count;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) return;

    if (_cartItems[productId]!.quantity > 1) {
      _cartItems.update(
          productId,
          (exisitingItem) => CartItem(
                id: exisitingItem.id,
                title: exisitingItem.title,
                quantity: exisitingItem.quantity - 1,
                price: exisitingItem.price,
              ));
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }
}
