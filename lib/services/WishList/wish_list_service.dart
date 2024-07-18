// 📦 Package imports:
import 'package:dio/dio.dart';

// 🌎 Project imports:
import 'package:techshop_app/services/API/ApiService.dart';

class WishListService {
  final ApiService _apiService = ApiService(Dio());

  Future<Response<dynamic>> getWishList() async {
    try {
      final response = await _apiService.get('/wishlist');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> addToWishList(String productId) async {
    try {
      final response = await _apiService
          .post('/wishlist/add', data: {'productId': productId});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> removeFromWishList(String productId) async {
    try {
      final response = await _apiService
          .delete('/wishlist/remove', data: {'productId': productId});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
