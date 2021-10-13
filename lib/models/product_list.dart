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

  void addProduct(Product product) {
    _items.add(product);

    // notifyListener() é responsavel por notificar
    // os objetos que estao utilizando a lista de produtos
    // para que a atualização da tela ocorra
    notifyListeners();
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