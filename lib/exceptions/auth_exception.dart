class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'O email já foi cadastrado',
    'OPERATION_NOT_ALLOWED': 'O cadastro está temporariamente desativado',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Muitas tentativas, tente novamente mais tarde',
    'EMAIL_NOT_FOUND': 'O email não foi encontrado',
    'INVALID_PASSWORD': 'O email ou a senha estão incorretos',
    'USER_DISABLED': 'Tomou ban men, TURURUUUUUU',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro na autenticação';
  }
}
