import 'package:flutter/foundation.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product.dart';
import '../domain/entities/cart.dart';
import '../domain/entities/cart_item.dart';

class CartStore extends ChangeNotifier {
  Cart _cart = const Cart(items: []);

  Cart get cart => _cart;

  static const int maxDifferentProducts = 10;

  void addProduct(Product product) {
    if (_cart.isFinalized) return;

    final existingIndex = _cart.items.indexWhere(
      (item) => item.productId == product.id,
    );

    List<CartItem> updatedItems = List.from(_cart.items);

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] =
          existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      if (_cart.totalDifferentItems >= maxDifferentProducts) {
        return;
      }

      updatedItems.add(
        CartItem(
          productId: product.id,
          title: product.title,
          unitPrice: product.price,
          image: product.image,
          quantity: 1,
        ),
      );
    }

    _cart = Cart(items: updatedItems);
    notifyListeners();
  }

  void removeProduct(int productId) {
    if (_cart.isFinalized) return;

    final updatedItems = _cart.items
        .where(
          (item) => item.productId != productId,
        )
        .toList();

    _cart = Cart(items: updatedItems);
    notifyListeners();
  }

  void finalize() {
    _cart = Cart(
      items: _cart.items,
      isFinalized: true,
    );
    notifyListeners();
  }

  void reset() {
    _cart = const Cart(items: []);
    notifyListeners();
  }

  void addProductFromCart(CartItem item) {
    if (_cart.isFinalized) return;

    final index = _cart.items.indexWhere(
      (i) => i.productId == item.productId,
    );

    final updatedItems = List<CartItem>.from(_cart.items);

    updatedItems[index] = item.copyWith(quantity: item.quantity + 1);

    _cart = Cart(items: updatedItems);
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    if (_cart.isFinalized) return;

    final index = _cart.items.indexWhere((i) => i.productId == productId);

    if (index == -1) return;

    final updatedItems = List<CartItem>.from(_cart.items);
    final item = updatedItems[index];

    if (item.quantity > 1) {
      updatedItems[index] = item.copyWith(quantity: item.quantity - 1);
    } else {
      updatedItems.removeAt(index);
    }

    _cart = Cart(items: updatedItems);
    notifyListeners();
  }
}
