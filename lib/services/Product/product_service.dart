import 'package:dio/dio.dart';
import 'package:techshop_app/services/API/ApiService.dart';

class ProductService {
  final ApiService _apiService = ApiService(Dio());

  // Future<List<dynamic>> getProducts({int page = 1}) async {
  //   try {
  //     final response = await _apiService.get('/product?page=$page');
  //     return response.data;
  //   } on Exception catch (e) {
  //     // TODO
  //     print(e);
  //     rethrow;
  //   }
  // }

  Future<Response> getProducts() async {
    try {
      final Response<dynamic> response = await _apiService.get('/product');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProductById(String id) async {
    try {
      final response = await _apiService.get('/product/$id');
      return response.data;
    } on Exception catch (e) {
      // TODO
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
