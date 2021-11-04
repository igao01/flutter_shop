import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = [];

  // retorna um clone da lista para que as classes
  // que acessem o metodo get nao façam alterações diretamente
  // na lista de item e sim passe pelos métodos desta classe
  List<Product> get items => [..._items];

  // pega os favoritos
  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  // LOAD PRODUCT
  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(Uri.parse('${Constants.baseUrl}.json'));

    // sai do método caso o restorno da resposta seja nulo
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });
    notifyListeners();
  }

  // SAVE PRODUCT
  Future<void> saveProduct(Map<String, dynamic> data) async {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] : Random().nextDouble().toString(),
      name: data['name'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  // async e await executa codigo assincrono
  // como se fosse codigo sincrono
  Future<void> addProduct(Product product) async {
    // realiza uma requisicao POST
    final response = await http.post(
      // define o end da requisicao
      Uri.parse('${Constants.baseUrl}.json'),
      // passa o objeto no corpo da requisicao
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );
    // executa o método then() somente após receber
    // uma resposta do servidor

    // pega o id retornado pelo back-end
    final id = jsonDecode(response.body)['name'];

    // adiciona o novo produto a lista
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));

    // notifyListener() é responsavel por notificar
    // os objetos que estao utilizando a lista de produtos
    // para que a atualização da tela ocorra
    notifyListeners();
  }

  // UPDATE PRODUCT
  Future<void> updateProduct(Product product) async {
    // verifica se ja existe o produto na lista
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/${product.id}.json'),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );
      // atualiza o produto na lista
      _items[index] = product;
      notifyListeners();
    }
  }

  // REMOVE PRODUCT
  Future<void> removeProduct(Product product) async {
    /*
      neste método está sendo utilizada a exclusão otimista
      o objeto é removido primeiramente na interface gráfica
      dando um feedback mais rápido para o usuário
    */

    // verifica se ja existe o produto na lista
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];

      // remove o produto na lista da interface gráfica
      _items.remove(product);
      notifyListeners();

      // realiza a requisicao para exluir no back-end
      final response = await http.delete(
        Uri.parse('${Constants.baseUrl}/${product.id}.json'),
      );

      // verifica se houve algum erro na requisicao
      if (response.statusCode >= 400) {
        // restaura o item na interface grafica
        // em caso de erro na requisicao
        // impossibilitando a remocao do item no back-end
        _items.insert(index, product);
        notifyListeners();

        throw HttpException(
          msg: 'Não foi possível excluir o produto',
          statusCode: response.statusCode,
        );
      }
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
