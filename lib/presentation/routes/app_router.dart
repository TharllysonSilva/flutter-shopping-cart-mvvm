import 'package:flutter/material.dart';

class AppRouter {
  static const products = '/products';
  static const cart = '/cart';
  static const checkoutSuccess = '/checkout-success';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case products:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      case cart:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      case checkoutSuccess:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
        );
      default:
        return null;
    }
  }
}