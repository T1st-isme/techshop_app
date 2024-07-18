// 🐦 Flutter imports:

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/WishList/Controller/wish_list_controller.dart';

class WishListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishListController>(() => WishListController());
    Get.lazyPut<CartController>(() => CartController());
  }
}
