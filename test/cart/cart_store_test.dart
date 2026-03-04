import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_shopping_cart_mvvm/data/services/cart_api.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/cart.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/cart_item.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product.dart';
import 'package:flutter_shopping_cart_mvvm/store/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/cart_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/core/result/result.dart';

class MockCartApi extends Mock implements CartApi {}

void main() {
  late CartStore store;
  late CartViewModel viewModel;
  late MockCartApi api;

  setUpAll(() {
    registerFallbackValue(
      const Product(id: 0, title: 'fallback', price: 0, image: ''),
    );

    registerFallbackValue(
      const Cart(items: []),
    );
  });

  setUp(() {
    api = MockCartApi();
    store = CartStore();
    viewModel = CartViewModel(api, store);

    /// Simula comportamento real da API
    when(() => api.addProduct(
          current: any(named: 'current'),
          product: any(named: 'product'),
        )).thenAnswer((invocation) async {
      final current = invocation.namedArguments[#current] as Cart;
      final product = invocation.namedArguments[#product] as Product;

      final items = [...current.items];

      final index = items.indexWhere((item) => item.productId == product.id);

      if (index >= 0) {
        final item = items[index];
        items[index] = item.copyWith(quantity: item.quantity + 1);
      } else {
        items.add(
          CartItem(
            productId: product.id,
            title: product.title,
            image: product.image,
            unitPrice: product.price,
            quantity: 1,
          ),
        );
      }

      return Success(
        Cart(items: items),
      );
    });

    when(() => api.changeQuantity(
          current: any(named: 'current'),
          productId: any(named: 'productId'),
          delta: any(named: 'delta'),
        )).thenAnswer((_) async => Success(store.cart));

    when(() => api.removeProduct(
          current: any(named: 'current'),
          productId: any(named: 'productId'),
        )).thenAnswer((_) async => Success(store.cart));
  });

  test('não deve permitir mais de 10 produtos diferentes', () async {
    for (int i = 0; i < 10; i++) {
      await viewModel.add(
        Product(
          id: i,
          title: 'Produto $i',
          price: 10,
          image: '',
        ),
      );
    }

    expect(store.cart.totalDifferentItems, 10);

    await viewModel.add(
      const Product(
        id: 11,
        title: 'Produto extra',
        price: 10,
        image: '',
      ),
    );

    /// regra: máximo 10 produtos diferentes
    expect(store.cart.totalDifferentItems, 10);
  });
}
