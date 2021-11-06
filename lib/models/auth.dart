import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
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
    notifyListeners();
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
