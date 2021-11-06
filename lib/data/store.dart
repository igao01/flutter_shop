import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  // salva um dado <chave, valor> no armazenamento
  // interno do dispositivo
  static Future<bool> saveString(String key, String value) async {
    // pega a instancia do banco
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return saveString(key, jsonEncode(value));
  }

  // returna uma string salva no dispositivo
  static Future<String> getString(String key,
      [String defaultValue = '']) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    // caso ocorra algum erro na tentativa de recuperar o dado
    // retorna um objeto vazio
    try {
      return jsonDecode(await getString(key));
    } catch (_) {
      return {};
    }
  }

  // exclui um dado do armazenamento
  // interno do dispositivo
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
