import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_shopping_cart_mvvm/presentation/products/view/products_screen.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('ProductsScreen renders correctly', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const ProductsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
  });

  testWidgets('tap cart icon navigates to cart screen', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const ProductsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.shopping_cart));

    await tester.pumpAndSettle();

    expect(find.text('Carrinho'), findsOneWidget);
  });
}
