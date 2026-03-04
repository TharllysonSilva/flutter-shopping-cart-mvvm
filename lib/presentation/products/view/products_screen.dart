import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/cart_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/products_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/products_api.dart';
import 'package:flutter_shopping_cart_mvvm/core/result/result.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/widgets/cart_badge_icon.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/widgets/error_banner.dart';
import 'package:flutter_shopping_cart_mvvm/store/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/routes/app_router.dart';
import 'package:provider/provider.dart';

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
    final cartStore = context.watch<CartStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.cart);
            },
            icon: CartBadgeIcon(store: cartStore),
          ),
          const SizedBox(width: 8),
        ],
      ),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorBanner(
                    message: result?.error ?? "Erro ao carregar produtos",
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: viewModel.loadProducts,
                    child: const Text("Tentar novamente"),
                  ),
                ],
              ),
            );
          }

          if (result is Success<List<Product>>) {
            final products = result.data ?? [];

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                return _ProductTile(
                  product: product,
                  cartStore: cartStore,
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

class _ProductTile extends StatelessWidget {
  final Product product;
  final CartStore cartStore;

  const _ProductTile({
    required this.product,
    required this.cartStore,
  });

  @override
  Widget build(BuildContext context) {
    final cartItem = cartStore.cart.items
        .where((item) => item.productId == product.id)
        .firstOrNull;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(product.image, width: 60, height: 60),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "R\$ ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

           
            if (cartItem == null)
              ElevatedButton(
                onPressed: () {
                  context.read<CartViewModel>().add(product);
                },
                child: const Text("Adicionar"),
              )

           
            else
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<CartViewModel>().decrement(product.id);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    cartItem.quantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<CartViewModel>().add(product);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

extension FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
