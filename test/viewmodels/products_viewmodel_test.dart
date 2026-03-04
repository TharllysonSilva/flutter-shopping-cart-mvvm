import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_shopping_cart_mvvm/data/services/products_api.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/products_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product.dart';
import 'package:flutter_shopping_cart_mvvm/core/result/result.dart';

class MockProductsApi extends Mock implements ProductsApi {}

void main() {
  late ProductsViewModel viewModel;
  late MockProductsApi api;

  setUpAll(() {
    registerFallbackValue(
      const Product(
        id: 0,
        title: 'fallback',
        price: 0,
        image: '',
      ),
    );
  });

  setUp(() {
    api = MockProductsApi();
    viewModel = ProductsViewModel(api);
  });

  test('loadProducts should return Success when API succeeds', () async {
    when(() => api.fetchProducts()).thenAnswer(
      (_) async => const Success([
        Product(
          id: 1,
          title: 'Produto Teste',
          price: 10,
          image: '',
        ),
      ]),
    );

    await viewModel.loadProducts();

    final result = viewModel.loadProductsCommand.result;

    expect(result, isA<Success>());
    expect((result as Success).data.length, 1);
  });

  test('loadProducts should return Failure when API fails', () async {
    when(() => api.fetchProducts()).thenAnswer(
      (_) async => const Failure('Erro ao buscar produtos'),
    );

    await viewModel.loadProducts();

    final result = viewModel.loadProductsCommand.result;

    expect(result, isA<Failure>());
  });
}
