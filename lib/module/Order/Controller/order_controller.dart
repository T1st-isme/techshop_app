import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:techshop_app/models/order.dart';
import 'package:techshop_app/services/API/ApiException.dart';
import 'package:techshop_app/services/Order/order_service.dart';

class OrderController extends GetxController {
  final OrderService orderService = Get.put(OrderService());
  RxList<Data> orders = RxList<Data>();
  Rx<Data?> orderDetail = Rx<Data?>(null);
  // Rx<bool> isLoading = Rx<bool>(false);
  Rx<RxStatus> status = Rx<RxStatus>(RxStatus.empty());

  @override
  void onInit() {
    super.onInit();
    getOrder();
  }

  Future<void> getOrder() async {
    Future.microtask(() => status.value = RxStatus.loading());
    try {
      final response = await orderService.getOrders();
      if (response.statusCode == 200) {
        final orderData = Order.fromJson(response.data);
        orders.value = orderData.data ?? [];
        Future.microtask(() => status.value = RxStatus.success());
      } else {
        throw Exception('Failed to get order');
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      Future.microtask(
          () => status.value = RxStatus.error(apiException.toString()));
      print(e);
    }
    update();
  }

  Future<void> getOrderDetail(String orderId) async {
    Future.microtask(() => status.value = RxStatus.loading());
    print('Fetching order details for orderId: $orderId');
    try {
      final response = await orderService.getOrderDetail(orderId);
      if (response.statusCode == 200 && response.data != null) {
        final orderData = response.data['data']['order'];
        orderDetail.value = Data.fromJson(orderData);
        Future.microtask(() => status.value = RxStatus.success());
        print('Order details fetched successfully');
      } else {
        throw Exception('Failed to get order detail');
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      Future.microtask(
          () => status.value = RxStatus.error(apiException.toString()));
      print(e);
    }
    update();
  }

  Future<String> createPaymentLink(int amount) async {
    Future.microtask(() => status.value = RxStatus.loading());
    try {
      final url = await orderService.createPaymentLink(amount);
      if (url.isNotEmpty) {
        Future.microtask(() => status.value = RxStatus.success());
      }
      return url;
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      Future.microtask(
          () => status.value = RxStatus.error(apiException.toString()));
      rethrow;
    }
  }

  void resetOrder() {
    orders.clear();
    orderDetail.value = null;
  }
}
