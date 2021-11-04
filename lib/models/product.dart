import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<String> toggleFavorite() async {
    // msg recebe o que será retornado pelo future
    // verifica se é favorito e
    // exibe removido ao remover a marcacao de favorito
    var msg =
        isFavorite ? 'Removido dos favoritos' : 'Adicionado aos favoritos';

    _toggleFavorite();

    try {
      await http.patch(
        Uri.parse('${Constants.baseUrl}/$id.json'),
        body: jsonEncode(
          {
            "isFavorite": isFavorite,
          },
        ),
      );
    } catch (error) {
      // volta a marcacao inicial em caso de erro na requisicao
      _toggleFavorite();
      // retorna pro usuario a mensagem de erro
      msg = isFavorite
          ? 'Não foi possível desmarcar o produto'
          : 'Não foi possível marcar o produto';
    }
    return msg;
  }
}
