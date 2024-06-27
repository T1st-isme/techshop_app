import 'package:get/get.dart';
import 'package:techshop_app/models/cart.dart';

import '../../../services/Cart/cart_service.dart';

class CartController extends GetxController with StateMixin<List<CartItems>> {
  var cartItems = List<CartItems>.empty(growable: true).obs;
  var totalItems = 0.obs;
  var totalPrice = 0.0.obs;
  var totalQuantity = 0.obs;
  final CartService _cartService = CartService();
  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  void fetchCartItems() async {
    final response = await _cartService.getCartItems();
    if (response.statusCode == 200) {
      final dataCart = response.data['cartItems'];
      List<CartItems> cartItemsList =
          dataCart.map<CartItems>((item) => CartItems.fromJson(item)).toList();
      cartItems.addAll(cartItemsList);
      change(cartItems, status: RxStatus.success());
      totalItems.value = response.data['total_items'];
      totalPrice.value = double.parse(response.data['total_price']);
      totalQuantity.value = response.data['total_quantity'];
    } else {
      Get.snackbar('Error', 'Failed to fetch cart items');
    }
  }
}
