import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_cart_mvvm/presentation/products/view/products_screen.dart';
import 'package:flutter_shopping_cart_mvvm/store/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/cart_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/checkout_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/cart_api.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/checkout_api.dart';

void main() {
  testWidgets('ProductsScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
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
        child: const MaterialApp(
          home: ProductsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.byType(ProductsScreen), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
  });
}
