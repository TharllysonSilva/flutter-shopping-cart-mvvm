import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/routes/app_router.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_cart_mvvm/store/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/cart_api.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/checkout_api.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/cart_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/checkout_viewmodel.dart';

Widget buildTestApp(Widget child) {
  return MultiProvider(
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
    child: MaterialApp(
      home: child,
      onGenerateRoute: AppRouter.onGenerateRoute,
    ),
  );
}
