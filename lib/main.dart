import 'package:flutter/material.dart';
import 'presentation/routes/app_router.dart';

void main() {
  runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shopping Cart MVVM',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.products,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
