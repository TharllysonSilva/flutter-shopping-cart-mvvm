import 'dart:math';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product.dart';

import '../../core/result/result.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

class CartApi {
  Future<Result<Cart>> addProduct({
    required Cart current,
    required Product product,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (Random().nextBool()) {
      return const Failure("Falha ao adicionar produto no carrinho.");
    }

    final items = List<CartItem>.from(current.items);
    final index = items.indexWhere((i) => i.productId == product.id);

    if (index >= 0) {
      final existing = items[index];
      items[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      items.add(
        CartItem(
          productId: product.id,
          title: product.title,
          unitPrice: product.price,
          image: product.image,
          quantity: 1,
        ),
      );
    }

    return Success(Cart(items: items, isFinalized: current.isFinalized));
  }

  Future<Result<Cart>> removeProduct({
    required Cart current,
    required int productId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (Random().nextBool()) {
      return const Failure("Falha ao remover produto do carrinho.");
    }

    final items = current.items.where((i) => i.productId != productId).toList();
    return Success(Cart(items: items, isFinalized: current.isFinalized));
  }

  Future<Result<Cart>> changeQuantity({
    required Cart current,
    required int productId,
    required int delta,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (Random().nextBool()) {
      return const Failure("Falha ao atualizar quantidade no carrinho.");
    }

    final items = List<CartItem>.from(current.items);
    final index = items.indexWhere((i) => i.productId == productId);
    if (index == -1) return Success(current);

    final item = items[index];
    final nextQty = item.quantity + delta;

    if (nextQty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(quantity: nextQty);
    }

    return Success(Cart(items: items, isFinalized: current.isFinalized));
  }
}
