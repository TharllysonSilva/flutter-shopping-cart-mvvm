import 'package:flutter_shopping_cart_mvvm/domain/entities/cart_item.dart';

class OrderSummary {
  final List<CartItem> items;
  final double subtotal;
  final double freight;

  const OrderSummary({
    required this.items,
    required this.subtotal,
    required this.freight,
  });

  double get total => subtotal + freight;
}
