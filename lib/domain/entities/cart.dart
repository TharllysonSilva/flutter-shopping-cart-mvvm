import 'cart_item.dart';

class Cart {
  final List<CartItem> items;
  final bool isFinalized;

  const Cart({
    required this.items,
    this.isFinalized = false,
  });

  int get totalDifferentItems => items.length;

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.subtotal);
}