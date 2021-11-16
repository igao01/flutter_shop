import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // verifica qual a rota para atribuir uma animacao especifica
    // if(setting.name == '/'){
    //  return child;
    // }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransictionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // verifica qual a rota para atribuir uma animacao especifica
    // if(route.setting.name == '/'){
    //  return child;
    // }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
