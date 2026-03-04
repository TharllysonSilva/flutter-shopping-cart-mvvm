import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/view/cart_screen.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/view/products_screen.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/checkout_success_screen.dart';

class AppRouter {
  static const products = '/products';
  static const cart = '/cart';
  static const checkoutSuccess = '/checkout-success';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case products:
        return MaterialPageRoute(
          builder: (_) => const ProductsScreen(),
        );
      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );
      case checkoutSuccess:
        return MaterialPageRoute(
          builder: (_) => const CheckoutSuccessScreen(),
        );
      default:
        return null;
    }
  }
}
