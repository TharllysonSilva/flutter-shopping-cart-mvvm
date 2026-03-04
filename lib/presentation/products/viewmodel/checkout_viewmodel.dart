import 'package:flutter/foundation.dart';
import '../../../core/command/command.dart';
import '../../../core/result/result.dart';
import '../../../data/services/checkout_api.dart';
import '../../../store/cart_store.dart';

class CheckoutViewModel extends ChangeNotifier {
  final CheckoutApi _api;
  final CartStore _store;

  late final Command<void> checkoutCommand;

  CheckoutViewModel(this._api, this._store) {
    checkoutCommand = Command<void>();
  }

  Future<void> checkout() async {
    await checkoutCommand.execute(() async {
      final cart = _store.cart;

      if (cart.items.isEmpty) {
        return const Failure("Carrinho vazio.");
      }

      if (cart.isFinalized) {
        return const Failure("Carrinho já finalizado.");
      }

      final result = await _api.checkout(cart);

      if (result is Failure) {
        return Failure<void>(result.error ?? "Erro no checkout");
      }

      _store.finalizeOrder(result.data!);
      return const Success(null);
    });
  }

  void newOrder() {
    _store.reset();
  }
}
