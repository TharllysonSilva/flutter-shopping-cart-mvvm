class CartItem {
  final int productId;
  final String title;
  final double unitPrice;
  final String image;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.title,
    required this.unitPrice,
    required this.image,
    required this.quantity,
  });

  double get subtotal => unitPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      title: title,
      unitPrice: unitPrice,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }
}