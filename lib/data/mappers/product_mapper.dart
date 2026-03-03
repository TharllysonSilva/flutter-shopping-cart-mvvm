import '../../domain/product.dart';
import '../dto/product_dto.dart';

class ProductMapper {
  static Product toEntity(ProductDTO dto) {
    return Product(
      id: dto.id,
      title: dto.title,
      price: dto.price,
      image: dto.image,
    );
  }
}