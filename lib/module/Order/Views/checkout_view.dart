// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Order/Controller/order_controller.dart';

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
    final authController = Get.find<AuthController>();
    final cartController = Get.find<CartController>();
    var isLoading = false;
    var totalPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
        .format(cartController.totalPrice.toDouble());
    var totalPriceInt = int.parse(totalPrice.replaceAll(RegExp(r'[^0-9]'), ''));
    print(totalPriceInt);

    Future<void> checkout() async {
      try {
        setState(() => isLoading = true);

        final response = await orderController.createPaymentLink(totalPriceInt);
        final url = Uri.parse(response['url']!);
        print("MaGD: ${response['orderCode']}");
        print("linkGD: ${response['url']}");
        final orderCode = response['orderCode'];
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
          await orderController.getOrder();
          Future.microtask(
            () => orderController.handlePaymentResult(
              orderCode!,
              url.toString(),
            ),
          );
        } else {
          throw Exception("Không thể mở liên kết!");
        }
      } on Exception catch (e) {
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
        child: Obx(
          () {
            if (!authController.isLoggedIn) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn phải đăng nhập để mua hàng!!!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: const Text('Đăng nhập'),
                  ),
                ],
              );
            }

            return Column(
              children: [
                ListTile(
                  title: const Text('Địa chỉ giao hàng',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(authController.user.user!.address ?? ''),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Row(
                    children: [
                      const Text('Phương thức thanh toán',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Image.asset(
                        'assets/images/Order/vietqr.png',
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to payment method selection
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index].cartItem!;
                      final formatter = NumberFormat('#,###', 'vi_VN');
                      final value = item.price!;
                      final formatPrice = formatter.format(value * 1000000);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: item.img ?? '',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            fadeInDuration: const Duration(milliseconds: 200),
                            fadeOutDuration: const Duration(milliseconds: 200),
                          ),
                          title: Text(item.name ?? ''),
                          subtitle: Text(
                            'Số lượng: ${item.quantity}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            '$formatPrice₫',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng tiền hàng',
                        style: TextStyle(color: Colors.grey)),
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                          .format(cartController.totalPrice.toDouble()),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Phí vận chuyển',
                        style: TextStyle(color: Colors.grey)),
                    Text('30.000 ₫'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng thanh toán',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(totalPrice,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        horizontal: 32.0, vertical: 20.0),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        totalPrice,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      const Text(
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
            );
          },
        ),
      ),
    );
  }
}
