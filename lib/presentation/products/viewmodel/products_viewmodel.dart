import 'package:flutter/foundation.dart';
import '../../../core/command/command.dart';
import '../../../domain/entities/product.dart';
import '../../../data/services/products_api.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsApi _api;

  late final Command<List<Product>> loadProductsCommand;

  ProductsViewModel(this._api) {
    loadProductsCommand = Command<List<Product>>();
  }

  Future<void> loadProducts() async {
    await loadProductsCommand.execute(
      () => _api.fetchProducts(),
    );
  }
}