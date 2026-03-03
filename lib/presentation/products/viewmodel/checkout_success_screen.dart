import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../store/cart_store.dart';
import '../../routes/app_router.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  const CheckoutSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CartStore>();
    final order = store.lastOrder;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedido finalizado"),
        automaticallyImplyLeading: false,
      ),
      body: order == null
          ? const Center(child: Text("Nenhum pedido encontrado."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (_, index) {
                      final item = order.items[index];
                      return ListTile(
                        leading:
                            Image.network(item.image, width: 50, height: 50),
                        title: Text(item.title,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          "Qtd: ${item.quantity} • Unit: R\$ ${item.unitPrice.toStringAsFixed(2)}",
                        ),
                        trailing:
                            Text("R\$ ${item.subtotal.toStringAsFixed(2)}"),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                          "Subtotal: R\$ ${order.subtotal.toStringAsFixed(2)}"),
                      Text("Frete: R\$ ${order.freight.toStringAsFixed(2)}"),
                      const SizedBox(height: 8),
                      Text(
                        "Total: R\$ ${order.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          store.reset();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRouter.products,
                            (_) => false,
                          );
                        },
                        child: const Text("Novo pedido"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
