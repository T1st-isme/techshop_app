import 'package:get/get.dart';
import 'package:techshop_app/models/user.dart';
import 'package:techshop_app/services/Auth/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final _user = User().obs;
  User get user => _user.value;

  Future<bool> login(String email, String password) async {
    try {
      _user.value = await _authService.login(email, password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(String fullname, String email, String password) async {
    try {
      _user.value = await _authService.register(fullname, email, password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _user.value = User();
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
