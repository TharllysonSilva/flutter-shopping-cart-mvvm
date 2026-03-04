import 'package:flutter/material.dart';
import '../../store/cart_store.dart';

class CartBadgeIcon extends StatelessWidget {
  final CartStore store;

  const CartBadgeIcon({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (_, __) {
        return Stack(
          children: [
            const Icon(Icons.shopping_cart),
            if (store.cart.totalDifferentItems > 0)
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  child: Text(
                    store.cart.totalDifferentItems.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}