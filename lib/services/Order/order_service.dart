import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:techshop_app/services/API/ApiService.dart';

class OrderService {
  final ApiService _apiService = ApiService(Dio());

  Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> orderData) async {
    final response = await _apiService.post('/order', data: orderData);
    return response.data;
  }

  //get orders
  Future<Response> getOrders() async {
    try {
      final response = await _apiService.get('/order/me/order');
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //get order detail
  Future<Response> getOrderDetail(String orderId) async {
    try {
      final response =
          await _apiService.get('/order/get-order-detail/$orderId');
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> createPaymentLink(int amount) async {
    const returnUrl = 'app://techshopflutter/checkout/order-success';
    const cancelUrl = 'app://techshopflutter/checkout/order-failed';

    try {
      final response = await _apiService.post('/order/create',
          data: jsonEncode(<String, dynamic>{
            'orderCode': DateTime.now().millisecondsSinceEpoch,
            'amount': amount,
            'description': 'Order #${DateTime.now().millisecondsSinceEpoch}',
            'returnUrl': returnUrl,
            'cancelUrl': cancelUrl,
          }));
      print("Thanh toán: ${response.data['data']['checkoutUrl']}");
      if (response.statusCode == 200) {
        return response.data['data']['checkoutUrl'];
      } else {
        throw Exception('Failed to create payment link');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        print('CORS error: ${e.message}');
      }
      rethrow;
    }
  }
}
