import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

/*


  ESTE ARQUIVO NAO ESTA SENDO UTILIZA
  ESTA AQUI SOMENTE PARA EXEMPLIFICAR UMA
  ANIMACAO UTILIZANDO O AnimationController


*/
enum AuthMode {
  login,
  signUp,
}

class AuthFormManualAnimation extends StatefulWidget {
  const AuthFormManualAnimation({Key? key}) : super(key: key);

  @override
  _AuthFormManualAnimationState createState() =>
      _AuthFormManualAnimationState();
}

class _AuthFormManualAnimationState extends State<AuthFormManualAnimation>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<Size>? _heightAnimation;

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signUp;

  @override
  void initState() {
    super.initState();
    // TickerProvider é responsavel por chamar uma funcao
    // a cada frame do flutter
    // (por padrao flutter utiliza 60 frames por segundo)

    // animationController recebe um TickerProvider
    // Utilizando o mixin SingleTikerProviderStateMixin
    // o proprio AuthForm se torna um TickerProvider
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Tween define a altura de inicio e termino da animacao
    _heightAnimation = Tween(
      begin: const Size(double.infinity, 310),
      end: const Size(double.infinity, 395),
    ).animate(
      // define como a animacao sera realizada
      // se inicia lenta e termina rápid etc...
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  // SWITCH AUTH MODE
  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signUp;

        // inicia a animacao
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;

        // reverte a animcacao
        _controller?.reverse();
      }
    });
  }

  // ERROR DIALOG
  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  // SUBMIT
  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    final auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_isLogin()) {
        // login
        await auth.signin(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedBuilder(
        animation: _heightAnimation!,
        builder: (ctx, childForm) => Container(
          width: deviceSize.width * 0.75,
          height: _heightAnimation!.value.height,
          padding: const EdgeInsets.all(16),
          child: childForm,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um email válido';
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';

                  if (password.isEmpty) {
                    return 'Informe uma senha válida';
                  }

                  if (password.length < 5) {
                    return 'A senha deve ter no mínimo 5 caracteres';
                  }
                },
              ),
              if (_isSignup())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _authMode == AuthMode.login
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return "As senhas não são iguais";
                          }
                        },
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : ElevatedButton(
                      child: Text(
                        _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                      ),
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      ),
                    ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin()
                      ? 'Não possui conta? Cadastre-se'
                      : 'Já possui conta? Faça login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
