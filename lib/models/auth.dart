import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  // verifica se usuario esta logado
  bool get isAuth {
    final isValidExpiryDate = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValidExpiryDate;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  // Cadastrar
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  // Logar
  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  // auto logar
  Future<void> tryAutoLogin() async {
    // verifica se o usuario ja esta logado
    // se estiver sai do metodo
    if (isAuth) return;

    // verifica se tem um usuario salvo no dispositivo
    // se nao tem usuario sai do metodo
    // pois nao tem dados para tenta logar automatico
    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    // verifica se o tempo de expiracao do token ainda é valido
    // se for valido nao precisa realizar tentativa de login
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    // realiza o login atribuindo os dados
    // vindos do armazenamento do dispositivo
    // as variaveis em Auth e notificando os listeners
    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  // realiza a requisica alterando somente o urlFragment
  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyAP4ydPNwN_iKiJfEE1zvZgAhMNAy1izPU';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    // Verifica se houve algum erro
    // se sim, passa a chave do erro para AuthException
    // AuthException retorna a mensagem de acordo com
    // a chave recebida
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      // pega os valores retornados pelo back-end
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      // defina a data de expiracao do token
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      // salva os dados do usuário no dispositivo
      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearAutoLogoutTimer();

    // remove os dados do armazenamento do dispositivo
    // e notifica os listeners somente apos a conclusao
    // dessa tarefa
    Store.remove('userData').then(
      (value) => notifyListeners(),
    );
  }

  void _clearAutoLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearAutoLogoutTimer();

    // pega o tempo restante de validade do token
    Duration timeToLogout =
        _expiryDate?.difference(DateTime.now()) ?? const Duration(seconds: 0);

    _logoutTimer = Timer(
      timeToLogout,
      logout,
    );
  }
}
