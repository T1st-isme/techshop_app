import 'package:get/get.dart';
import 'package:techshop_app/module/Order/Controller/order_controller.dart';
import 'package:techshop_app/services/Order/order_service.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
    Get.lazyPut<OrderService>(() => OrderService());
  }
}
