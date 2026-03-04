import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_shopping_cart_mvvm/data/services/products_api.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/products_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/core/result/result.dart';

class MockProductsApi extends Mock implements ProductsApi {}

void main() {
  late ProductsViewModel viewModel;
  late MockProductsApi api;

  setUp(() {
    api = MockProductsApi();
    viewModel = ProductsViewModel(api);
  });

  test('deve carregar produtos com sucesso', () async {
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

    expect(result, isA<Success<List<Product>>>());
    expect((result as Success).data!.length, 1);
  });

  test('deve retornar erro quando api falhar', () async {
    when(() => api.fetchProducts()).thenAnswer(
      (_) async => const Failure("Erro ao buscar produtos"),
    );

    await viewModel.loadProducts();

    final result = viewModel.loadProductsCommand.result;

    expect(result, isA<Failure>());
  });
}
