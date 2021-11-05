import 'package:flutter/material.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/utils/app_routes.dart';

import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';

class AppPages {
  static Map<String, Widget Function(BuildContext)> pages = {
    AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
    AppRoutes.productDetail: (ctx) => const ProductDetailPage(),
    AppRoutes.cart: (ctx) => const CartPage(),
    AppRoutes.order: (ctx) => const OrdersPage(),
    AppRoutes.products: (ctx) => const ProductsPage(),
    AppRoutes.productForm: (ctx) => const ProductFormPage(),
  };
}
