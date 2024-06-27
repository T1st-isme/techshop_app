import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techshop_app/models/user.dart';
import 'package:techshop_app/services/API/ApiService.dart';

class AuthService {
  final ApiService _apiService = ApiService(Dio());

  Future<User> login(String email, String password) async {
    final response = await _apiService.post(
      '/user/login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(response.data));
      print(response.data['token'] ?? '');
      await prefs.setString('token', response.data['token'] ?? '');
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> register(String fullname, String email, String password) async {
    final response = await _apiService.post(
      '/user/signup',
      data: {'fullname': fullname, 'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(response.data));
      await prefs.setString('token', jsonEncode(response.data['token'] ?? ''));
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user');
  }
}
