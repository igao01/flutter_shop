import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/data/dummy_products.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  // retorna um clone da lista para que as classes
  // que acessem o metodo get nao façam alterações diretamente
  // la lista de item e sim passe pelos métodos desta classe
  List<Product> get items => [..._items];

  // pega os favoritos
  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  void saveProduct(Map<String, dynamic> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] : Random().nextDouble().toString(),
      name: data['name'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
    );

    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void addProduct(Product product) {
    _items.add(product);

    // notifyListener() é responsavel por notificar
    // os objetos que estao utilizando a lista de produtos
    // para que a atualização da tela ocorra
    notifyListeners();
  }

  void updateProduct(Product product) {
    // verifica se ja existe o produto na lista
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      // atualiza o produto na lista
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    // verifica se ja existe o produto na lista
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      // remove o produto na lista
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }
}


/*  CODIGO UTILIZADO NA EXPLICACAO DO FILTRO COM GERENCIAMENTO
    DE ESTADO GLOBAL
*/
// List<Product> get items {
//     if (_showFavoriteOnly) {
//       return _items.where((product) => product.isFavorite).toList();
//     } else {
//       return [..._items];
//     }
//   }

  // bool _showFavoriteOnly = false;

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }