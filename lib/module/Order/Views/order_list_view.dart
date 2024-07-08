import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Auth/Views/check_login_view.dart';
import 'package:techshop_app/module/Order/Controller/order_controller.dart';
import 'package:techshop_app/module/Order/Views/order_emty_view.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final OrderController orderController = Get.find<OrderController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    orderController.getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (orderController.status.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!authController.isLoggedIn) {
          return const CheckLoginView();
        }
        if (orderController.orders.isEmpty) {
          return const OrderEmptyView();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Đơn hàng',
                style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                      checkmarkColor: Colors.white,
                      label: const Text(
                        'Đang xử lý',
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: true,
                      onSelected: (bool value) {},
                      selectedColor: const Color.fromARGB(255, 162, 95, 230),
                    ),
                    FilterChip(
                      label: const Text('Vận chuyển'),
                      selected: false,
                      onSelected: (bool value) {},
                    ),
                    FilterChip(
                      label: const Text('Đã giao'),
                      selected: false,
                      onSelected: (bool value) {},
                    ),
                    FilterChip(
                      label: const Text('Đã hủy'),
                      selected: false,
                      onSelected: (bool value) {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: orderController.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderController.orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('Đơn #${order.orderCode}'),
                        subtitle: Text('${order.items?.length ?? 0} sản phẩm'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          if (order.sId != null && order.sId!.isNotEmpty) {
                            Get.toNamed(
                              Routes.ORDERDETAIL,
                              parameters: {
                                'orderId': order.sId!,
                              },
                            );
                          } else {
                            Get.snackbar('Error', 'Order ID is null or empty');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
