import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Cart/Views/cart_empty_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController _cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _cartController.fetchCartItems();
  }

  void _incrementQuantity(String itemId, int currentQuantity) {
    _cartController.updateCartItemQuantity(itemId, currentQuantity + 1);
  }

  void _decrementQuantity(String itemId, int currentQuantity) {
    if (currentQuantity > 1) {
      _cartController.updateCartItemQuantity(itemId, currentQuantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: _cartController,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Giỏ hàng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // _cartController.clearCart();
                },
                child: const Text(
                  'Xóa tất cả',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          body: Obx(() {
            if (_cartController.cartItems.isEmpty) {
              return const CartEmptyView();
            }
            return ListView.builder(
              itemCount: _cartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartController.cartItems[index];
                final formatter = NumberFormat('#,###', 'vi_VN');
                final value = item.cartItem!.price!;
                final formatPrice = formatter.format(value * 1000000);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(item.cartItem!.img!),
                    title: Text(item.cartItem!.name!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove,
                                  color: Colors.purple),
                              onPressed: () {
                                _decrementQuantity(item.cartItem!.sId!,
                                    item.cartItem!.quantity!);
                              },
                            ),
                            Text('${item.cartItem!.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.purple),
                              onPressed: () {
                                _incrementQuantity(item.cartItem!.sId!,
                                    item.cartItem!.quantity!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      '$formatPrice đ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          bottomNavigationBar: Obx(() {
            if (_cartController.cartItems.isEmpty) {
              return const SizedBox
                  .shrink(); // Return an empty widget if the cart is empty
            }
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng tiền hàng'),
                      Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                            .format(_cartController.totalPrice.toDouble()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phí vận chuyển'),
                      Text('30.000đ'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng thanh toán',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                            .format((_cartController.totalPrice + 30000)
                                .toDouble()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.discount, color: Colors.green),
                      hintText: 'Nhập mã giảm giá',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward,
                            color: Color.fromARGB(255, 162, 95, 230)),
                        onPressed: () {
                          //discount logic
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Checkout logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 162, 95, 230),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Mua hàng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
