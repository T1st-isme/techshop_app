import 'package:get/get.dart';
import 'package:techshop_app/models/user.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Order/Controller/order_controller.dart';
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
      Get.find<CartController>().resetCart(); // Reset the cart state
      Get.find<OrderController>().resetOrder(); // Reset the order state
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
