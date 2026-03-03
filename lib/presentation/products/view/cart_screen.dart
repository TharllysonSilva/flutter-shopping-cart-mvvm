import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_cart_mvvm/store/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/routes/app_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartStore = context.watch<CartStore>();
    final cart = cartStore.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text("Seu carrinho está vazio"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (_, index) {
                      final item = cart.items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Image.network(
                                item.image,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "R\$ ${item.unitPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Subtotal: R\$ ${item.subtotal.toStringAsFixed(2)}",
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: cart.isFinalized
                                        ? null
                                        : () => cartStore
                                            .addProductFromCart(item),
                                    icon: const Icon(Icons.add_circle),
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: cart.isFinalized
                                        ? null
                                        : () => cartStore
                                            .decreaseQuantity(item.productId),
                                    icon:
                                        const Icon(Icons.remove_circle),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: cart.isFinalized
                                    ? null
                                    : () => cartStore
                                        .removeProduct(item.productId),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _CartSummary(),
              ],
            ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartStore = context.watch<CartStore>();
    final cart = cartStore.cart;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Itens diferentes: ${cart.totalDifferentItems}"),
          Text("Total de itens: ${cart.totalItems}"),
          const SizedBox(height: 8),
          Text(
            "Subtotal: R\$ ${cart.subtotal.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: cart.items.isEmpty || cart.isFinalized
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.checkoutSuccess,
                    );
                  },
            child: const Text("Finalizar pedido"),
          ),
        ],
      ),
    );
  }
}