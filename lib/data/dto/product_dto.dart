class ProductDTO {
  final int id;
  final String title;
  final double price;
  final String image;

  ProductDTO({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}