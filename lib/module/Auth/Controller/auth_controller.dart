import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techshop_app/models/user.dart';
import 'package:techshop_app/services/Auth/auth_service.dart';

class AuthController extends GetxController {
  var user = Rxn<User>();
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    try {
      final data = await _authService.login(email, password);
      user.value = User.fromJson(data);
      // Store user data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(data));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String fullname, String email, String password) async {
    try {
      final data = await _authService.register(fullname, email, password);
      user.value = User.fromJson(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      user.value = null;
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<String?> getToken() async {
    return _authService.getToken();
  }

  Future<bool> isLoggedIn() async {
    return _authService.isLoggedIn();
  }
}
