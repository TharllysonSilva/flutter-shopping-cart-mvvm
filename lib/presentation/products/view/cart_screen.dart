import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/presentation/products/viewmodel/checkout_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../core/result/result.dart';
import '../../../store/cart_store.dart';
import '../viewmodel/cart_viewmodel.dart';
import '../../routes/app_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CartStore>();
    final cartVm = context.watch<CartViewModel>();
    final checkoutVm = context.watch<CheckoutViewModel>();
    final cart = store.cart;

    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho")),
      body: Column(
        children: [
          // Feedback de operações (cart ops + checkout)
          _OperationFeedback(cartVm: cartVm, checkoutVm: checkoutVm),

          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text("Seu carrinho está vazio"))
                : ListView.builder(
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
                              Image.network(item.image, width: 60, height: 60),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(
                                      "R\$ ${item.unitPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                        "Subtotal: R\$ ${item.subtotal.toStringAsFixed(2)}"),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: store.isFinalized
                                        ? null
                                        : () =>
                                            cartVm.increment(item.productId),
                                    icon: const Icon(Icons.add_circle),
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: store.isFinalized
                                        ? null
                                        : () =>
                                            cartVm.decrement(item.productId),
                                    icon: const Icon(Icons.remove_circle),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: store.isFinalized
                                    ? null
                                    : () => cartVm.remove(item.productId),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          _CartSummaryAndCheckoutButton(checkoutVm: checkoutVm),
        ],
      ),
    );
  }
}

class _OperationFeedback extends StatelessWidget {
  final CartViewModel cartVm;
  final CheckoutViewModel checkoutVm;

  const _OperationFeedback({
    required this.cartVm,
    required this.checkoutVm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: cartVm.cartOperationCommand,
          builder: (_, __) {
            final cmd = cartVm.cartOperationCommand;
            final result = cmd.result;

            if (cmd.isExecuting) {
              return const LinearProgressIndicator();
            }

            if (result is Failure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                cmd.clear();
              });

              return _ErrorBanner(
                message: result.error ?? "Erro no carrinho",
              );
            }

            return const SizedBox.shrink();
          },
        ),
        AnimatedBuilder(
          animation: checkoutVm.checkoutCommand,
          builder: (_, __) {
            final cmd = checkoutVm.checkoutCommand;
            final result = cmd.result;

            if (cmd.isExecuting) {
              return const LinearProgressIndicator();
            }

            if (result is Failure) {
              return _ErrorBanner(message: result.error ?? "Erro no checkout");
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class _CartSummaryAndCheckoutButton extends StatelessWidget {
  final CheckoutViewModel checkoutVm;

  const _CartSummaryAndCheckoutButton({
    required this.checkoutVm,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CartStore>();
    final cart = store.cart;

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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "Total: R\$ ${cart.subtotal.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: cart.items.isEmpty || store.isFinalized
                ? null
                : () async {
                    await checkoutVm.checkout();

                    final result = checkoutVm.checkoutCommand.result;
                    if (result is Success) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.checkoutSuccess,
                        (_) => false,
                      );
                    }
                  },
            child: const Text("Finalizar pedido"),
          ),
        ],
      ),
    );
  }
}
