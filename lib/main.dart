import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/routes/app_router.dart';
import 'store/cart_store.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartStore(),
      child: const ShoppingCartApp(),
    ),
  );
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