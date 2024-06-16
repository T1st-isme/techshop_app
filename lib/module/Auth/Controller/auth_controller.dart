import 'package:get/get.dart';
import 'package:techshop_app/models/user.dart';
import 'package:techshop_app/services/Auth/auth_service.dart';

class AuthController extends GetxController {
  var user = Rxn<User>();
  final AuthService _authService = AuthService();

  void login(String email, String password) async {
    final data = await _authService.login(email, password);
    user.value = User.fromJson(data);
  }

  void register(String fullname, String email, String password) async {
    final data = await _authService.register(fullname, email, password);
    user.value = User.fromJson(data);
  }

  void logout() {
    user.value = null;
  }
}
