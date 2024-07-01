import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: _cartController,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            automaticallyImplyLeading: true,
          ),
          body: Obx(() {
            if (_cartController.cartItems.isEmpty) {
              return const CartEmptyView();
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
          bottomNavigationBar: Obx(
            () => Container(
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
            ),
          ),
        );
      },
    );
  }
}
