import 'dart:math';
import 'package:flutter_shopping_cart_mvvm/data/services/order_summary.dart';

import '../../core/result/result.dart';
import '../../domain/entities/cart.dart';

class CheckoutApi {
  Future<Result<OrderSummary>> checkout(Cart cart) async {
    await Future.delayed(const Duration(seconds: 1));

    if (Random().nextBool()) {
      return const Failure("Falha ao finalizar o pedido. Tente novamente.");
    }

    // Frete simulado
    final freight = (5 + Random().nextInt(16)).toDouble(); // 5..20

    final summary = OrderSummary(
      items: cart.items,
      subtotal: cart.subtotal,
      freight: freight,
    );

    return Success(summary);
  }
}
