import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/module/Order/Controller/order_controller.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng'),
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
                  label: const Text('Đang xử lý'),
                  selected: true,
                  onSelected: (bool value) {},
                  selectedColor: Colors.purple,
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
            child: Obx(() {
              if (orderController.status.value == RxStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (orderController.orders.isEmpty) {
                return const Center(child: Text('No orders found'));
              }
              return ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  final order = orderController.orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: Text('Đơn #${order.sId}'),
                      subtitle: Text('${order.items?.length ?? 0} items'),
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
              );
            }),
          ),
        ],
      ),
    );
  }
}
