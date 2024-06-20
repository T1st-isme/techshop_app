import 'package:dio/dio.dart';
import 'package:techshop_app/services/API/ApiService.dart';

class ProductService {
  final ApiService _apiService = ApiService(Dio());

  Future<Response> getProducts(int page) async {
    try {
      final Response<dynamic> response =
          await _apiService.get('/product?page=$page');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProductBySlug(String slug) async {
    try {
      final response = await _apiService.get('/product/$slug');
      return response.data['data'];
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createProduct(
      Map<String, dynamic> productData) async {
    final response = await _apiService.post('/product', data: productData);
    return response.data;
  }
}
