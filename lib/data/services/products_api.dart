import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../../core/result/result.dart';
import '../dto/product_dto.dart';
import '../mappers/product_mapper.dart';
import '../../domain/product.dart';

class ProductsApi {
  final _client = http.Client();

  Future<Result<List<Product>>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));

    // Simulação de erro randômico
    if (Random().nextBool()) {
      return const Failure("Erro ao carregar produtos.");
    }

    try {
      final response = await _client.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode != 200) {
        return const Failure("Erro inesperado na API.");
      }

      final List decoded = jsonDecode(response.body);

      final products = decoded
          .map((json) => ProductMapper.toEntity(
                ProductDTO.fromJson(json),
              ))
          .toList();

      return Success(products);
    } catch (_) {
      return const Failure("Falha na comunicação com servidor.");
    }
  }
}