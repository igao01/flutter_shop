import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo User'),
            // remove o icone do drawer de dentro dele
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
            onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.homeRoute),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),            
            title: const Text('Pedidos'),
            onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.orderRoute),
          )
        ],
      ),
    );
  }
}
