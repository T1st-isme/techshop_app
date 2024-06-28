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
  Future<Map<String, dynamic>> getOrders() async {
    final response = await _apiService.get('/order');
    return response.data;
  }

  Future<String> createPaymentLink(int amount) async {
    final response = await _apiService.post('/createPaymentLink',
        data: jsonEncode(<String, dynamic>{
          'orderCode': DateTime.now().millisecondsSinceEpoch,
          'amount': amount,
          'description': 'Order #${DateTime.now().millisecondsSinceEpoch}',
          'returnUrl': '${Uri.base}/order_success',
          'cancelUrl': '${Uri.base}/order_failed',
        }));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.data);
      return jsonResponse['checkoutUrl'];
    } else {
      throw Exception('Failed to create payment link');
    }
  }
}
