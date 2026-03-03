import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/products_viewmodel.dart';
import '../../../../data/services/products_api.dart';
import '../../../../core/result/result.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final ProductsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ProductsViewModel(ProductsApi());
    viewModel.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: AnimatedBuilder(
        animation: viewModel.loadProductsCommand,
        builder: (context, _) {
          final command = viewModel.loadProductsCommand;

          if (command.isExecuting) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = command.result;

          if (result is Failure) {
            return Center(
              child: Text(result?.error ?? "Erro"),
            );
          }

          if (result is Success) {
            final products = result?.data ?? [];

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50),
                  title: Text(product.title),
                  subtitle: Text("R\$ ${product.price}"),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}