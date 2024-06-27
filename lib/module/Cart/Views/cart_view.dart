import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController _cartController = Get.find<CartController>();

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Obx(() {
        if (_cartController.cartItems.isEmpty) {
          return const Center(child: Text('No items in the cart'));
        }
        return ListView.builder(
          itemCount: _cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = _cartController.cartItems[index];
            return ListTile(
              leading: Image.network(item.cartItem!.img!),
              title: Text(item.cartItem!.name!),
              subtitle: Text('Quantity: ${item.cartItem!.quantity}'),
              trailing: IconButton(
                  icon: const Icon(Icons.delete), onPressed: () => {}),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total Items: ${_cartController.totalItems}'),
                Text('Total Price: ${_cartController.totalPrice}'),
                Text('Total Quantity: ${_cartController.totalQuantity}'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Checkout'),
                ),
              ],
            ),
          )),
    );
  }
}
