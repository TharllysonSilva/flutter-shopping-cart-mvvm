import 'package:flutter/foundation.dart';
import 'package:flutter_shopping_cart_mvvm/data/services/order_summary.dart';
import '../core/result/result.dart';
import '../domain/entities/cart.dart';

import '../domain/entities/product.dart';

class CartStore extends ChangeNotifier {
  static const int maxDifferentProducts = 10;

  Cart _cart = const Cart(items: []);
  OrderSummary? _lastOrder;

  Cart get cart => _cart;
  OrderSummary? get lastOrder => _lastOrder;

  bool get isFinalized => _cart.isFinalized;

  // Validações (regras de negócio) ficam aqui
  Result<void> validateAdd(Product product) {
    if (_cart.isFinalized) {
      return const Failure("Não é possível editar um carrinho finalizado.");
    }

    final exists = _cart.items.any((i) => i.productId == product.id);
    if (!exists && _cart.totalDifferentItems >= maxDifferentProducts) {
      return const Failure("Limite de 10 produtos diferentes no carrinho.");
    }

    return const Success(null);
  }

  Result<void> validateEdit() {
    if (_cart.isFinalized) {
      return const Failure("Não é possível editar um carrinho finalizado.");
    }
    return const Success(null);
  }

  void applyCart(Cart next) {
    _cart = next;
    notifyListeners();
  }

  void finalizeOrder(OrderSummary summary) {
    _lastOrder = summary;
    _cart = Cart(items: _cart.items, isFinalized: true);
    notifyListeners();
  }

  void reset() {
    _cart = const Cart(items: []);
    _lastOrder = null;
    notifyListeners();
  }
}
