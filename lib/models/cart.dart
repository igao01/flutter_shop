import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount => _totalCalc();

  // adiciona um item ao carrinho
  void addItem(Product product) {
    // verifica se aquele item ja foi adicionado
    // caso ja tenha sido ele adiciona +1 a quantidade
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      // adiciona um novo item ao carrinho
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existemItem) => CartItem(
          id: Random().nextDouble().toString(),
          productId: existemItem.id,
          name: existemItem.name,
          quantity: existemItem.quantity - 1,
          price: existemItem.price,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  double _totalCalc() {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
}
