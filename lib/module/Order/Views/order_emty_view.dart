import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderEmptyView extends StatelessWidget {
  const OrderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/Order/empty_order.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có đơn hàng nào',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/product');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 162, 95, 230),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Xem thêm sản phẩm',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
