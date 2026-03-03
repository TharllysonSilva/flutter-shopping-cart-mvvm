import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/cart_api.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/checkout_api.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/cart_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/checkout_viewmodel.dart';
import 'package:provider/provider.dart';

import 'presentation/routes/app_router.dart';
import 'store/cart_store.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartStore()),
        Provider(create: (_) => CartApi()),
        Provider(create: (_) => CheckoutApi()),
        ChangeNotifierProvider(
          create: (ctx) => CartViewModel(
            ctx.read<CartApi>(),
            ctx.read<CartStore>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CheckoutViewModel(
            ctx.read<CheckoutApi>(),
            ctx.read<CartStore>(),
          ),
        ),
      ],
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
