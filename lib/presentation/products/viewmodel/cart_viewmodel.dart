import 'package:flutter/foundation.dart';
import '../../../core/command/command.dart';
import '../../../core/result/result.dart';
import '../../../data/services/cart_api.dart';
import '../../../domain/entities/product.dart';
import '../../../store/cart_store.dart';

class CartViewModel extends ChangeNotifier {
  final CartApi _api;
  final CartStore _store;

  late final Command<void> cartOperationCommand;

  CartViewModel(this._api, this._store) {
    cartOperationCommand = Command<void>();
  }

  Future<void> add(Product product) async {
    final validation = _store.validateAdd(product);
    if (validation is Failure) {
      cartOperationCommand
          .execute(() async => Failure<void>(validation.error ?? "Erro"));
      return;
    }

    await cartOperationCommand.execute(() async {
      final result =
          await _api.addProduct(current: _store.cart, product: product);

      if (result is Failure) return Failure<void>(result.error ?? "Erro");

      _store.applyCart(result.data!);
      return const Success(null);
    });
  }

  Future<void> increment(int productId) async {
    final validation = _store.validateEdit();
    if (validation is Failure) {
      await cartOperationCommand
          .execute(() async => Failure<void>(validation.error ?? "Erro"));
      return;
    }

    await cartOperationCommand.execute(() async {
      final result = await _api.changeQuantity(
        current: _store.cart,
        productId: productId,
        delta: 1,
      );

      if (result is Failure) return Failure<void>(result.error ?? "Erro");
      _store.applyCart(result.data!);
      return const Success(null);
    });
  }

  Future<void> decrement(int productId) async {
    final validation = _store.validateEdit();
    if (validation is Failure) {
      await cartOperationCommand
          .execute(() async => Failure<void>(validation.error ?? "Erro"));
      return;
    }

    await cartOperationCommand.execute(() async {
      final result = await _api.changeQuantity(
        current: _store.cart,
        productId: productId,
        delta: -1,
      );

      if (result is Failure) return Failure<void>(result.error ?? "Erro");
      _store.applyCart(result.data!);
      return const Success(null);
    });
  }

  Future<void> remove(int productId) async {
    final validation = _store.validateEdit();
    if (validation is Failure) {
      await cartOperationCommand
          .execute(() async => Failure<void>(validation.error ?? "Erro"));
      return;
    }

    await cartOperationCommand.execute(() async {
      final result =
          await _api.removeProduct(current: _store.cart, productId: productId);

      if (result is Failure) return Failure<void>(result.error ?? "Erro");
      _store.applyCart(result.data!);
      return const Success(null);
    });
  }
}
