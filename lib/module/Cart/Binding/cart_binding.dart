import 'package:get/get.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/services/Cart/cart_service.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartService>(() => CartService());
    Get.lazyPut<CartController>(() => CartController());
  }
}
