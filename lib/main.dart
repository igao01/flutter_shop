import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_pages.dart';

import 'models/cart.dart';
import 'models/order_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // multi provider permite a utilização de vários providers
      providers: [
        // coloca o ProductList na raiz do projeto para ser
        // acessado de qualquer parte da arvore de widgets
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),

        // ProxyProvider é utilizado quando um provider
        // depende de outro
        // update recebe o contexto, o auth para ser
        // utilizado dentro do ProductList
        // e previous (versão anterior de ProductList)
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(auth.token ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        routes: AppPages.pages,
      ),
    );
  }
}
