import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Order/Controller/order_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() {
    return _CheckoutView();
  }
}

class _CheckoutView extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    var isLoading = false;

    Future<void> checkout() async {
      try {
        setState(() => isLoading = true);

        final response = await orderController.createPaymentLink(10000);
        final url = Uri.parse(response);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw Exception("Không thể mở liên kết!");
        }
      } on Exception catch (e) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Lỗi"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng thông báo
                  },
                  child: const Text("Đóng"),
                ),
              ],
            );
          },
        );
      }
      setState(() => isLoading = false);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mua hàng',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Địa chỉ giao hàng'),
              subtitle: const Text('132 Sư Vạn Hạnh Phường 12 Quận 10'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to address selection
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Phương thức thanh toán'),
              subtitle: const Row(
                children: [
                  Text('**** 4187'),
                  SizedBox(width: 8),
                  Icon(Icons.credit_card, color: Colors.red),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to payment method selection
              },
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng tiền hàng', style: TextStyle(color: Colors.grey)),
                Text('7.580.000₫'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phí vận chuyển', style: TextStyle(color: Colors.grey)),
                Text('30.000₫'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng thanh toán',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('7.610.000₫',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isLoading ? null : checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 162, 95, 230),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 25.0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '7.610.000₫',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    'Đặt hàng',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
