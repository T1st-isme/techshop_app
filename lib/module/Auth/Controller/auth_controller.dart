import 'package:get/get.dart';
import 'package:techshop_app/models/user.dart';
import 'package:techshop_app/services/Auth/auth_service.dart';

class AuthController extends GetxController {
  var user = Rxn<User>();
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    try {
      final data = await _authService.login(email, password);
      user.value = User.fromJson(data);
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

  void logout() {
    user.value = null;
  }
}
