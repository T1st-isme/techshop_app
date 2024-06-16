import 'package:get/get.dart';
import 'package:techshop_app/services/API/ApiService.dart';

class AuthService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService
        .post('/user/login', data: {'email': email, 'password': password});
    return response.data;
  }

  Future<Map<String, dynamic>> register(
      String fullname, String email, String password) async {
    final response = await _apiService.post('/user/signup',
        data: {'fullname': fullname, 'email': email, 'password': password});
    return response.data;
  }
}
