import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

import 'cart.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  // LOAD ORDER
  Future<void> loadOrders() async {
    _items.clear();
    final List<Order> items = _items;

    final response = await http.get(
        Uri.parse('${Constants.userOrderBaseUrl}/$_userId.json?auth=$_token'));

    // sai do método caso o restorno da resposta seja nulo
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],

          // converte os produtos para CartItem
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    productId: item['productId'],
                    name: item['name'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ),
      );
    });
    // exibe a lista em ordem decrescente
    _items = items.reversed.toList();
    notifyListeners();
  }

  // ADD ORDER
  Future<void> addOrder(Cart cart) async {
    // pega data atual
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.userOrderBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),

          // converte para json cada cartItem em items
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'name': cartItem.name,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        },
      ),
    );

    // pega o id retornado pelo back-end
    final id = jsonDecode(response.body)['name'];

    // insere os dados na lista da interface grafica
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
  }
}
