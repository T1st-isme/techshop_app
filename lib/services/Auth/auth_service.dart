import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techshop_app/services/API/ApiService.dart';

class AuthService {
  final ApiService _apiService = ApiService(Dio());

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService
        .post('/user/login', data: {'email': email, 'password': password});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.data['token']);
    return response.data;
  }

  Future<Map<String, dynamic>> register(
      String fullname, String email, String password) async {
    final response = await _apiService.post('/user/signup',
        data: {'fullname': fullname, 'email': email, 'password': password});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.data['token']);
    return response.data;
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    return true;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

// Future<Map<String, dynamic>> makeAuthenticatedRequest(String endpoint) async {
//   final token = await getToken();
//
//   if (token == null) {
//     throw Exception('No token found. User not logged in.');
//   }
//
//   // Add your API request logic here, using the token for authorization.
//   // For example, if you're using the `http` package:
//   /*
// final response = await http.get(
//   Uri.parse('https://yourapi.com/$endpoint'),
//   headers: {
//     'Authorization': 'Bearer $token',
//   },
// );
// */
//
//   // Return the response data or handle it as needed.
// }
}
