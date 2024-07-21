// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/constants/AppUrl.dart';
import 'package:timeline_tile/timeline_tile.dart';

// 🌎 Project imports:
import 'package:techshop_app/module/Order/Controller/order_controller.dart';

class OrderDetailView extends StatefulWidget {
  const OrderDetailView({super.key});

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final OrderController orderController = Get.find<OrderController>();
  final String? orderId = Get.parameters['orderId'];

  @override
  void initState() {
    super.initState();
    if (orderId != null) {
      orderController.getOrderDetail(orderId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(
        () {
          if (orderController.status.value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = orderController.orderDetail.value;
          if (order == null) {
            return const Center(child: Text('No order details available.'));
          }
          if (orderController.status.value.isError) {
            return Center(
                child: Text('Error: ${orderController.status.value}'));
          }
          if (orderController.status.value.isSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Mã đơn hàng: ${order.orderCode}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 20),
                  _buildOrderStatusTimeline(
                      order.orderStatus, order.updatedAt, order.createdAt),
                  const SizedBox(height: 20),
                  const Text('Sản phẩm đã đặt',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  ...order.items?.map((item) => Card(
                            color: Colors.grey[200],
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: item.productId?.proImg != null &&
                                      item.productId!.proImg!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          item.productId!.proImg!.first.img ??
                                              '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover)
                                  : null,
                              title: Text(item.productId?.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black)),
                              subtitle: Text('Số lượng: ${item.purchasedQty}',
                                  style: const TextStyle(color: Colors.grey)),
                              trailing: Text(
                                  '${formatter.format(item.payablePrice! * 1000000)} đ',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )) ??
                      [],
                  const SizedBox(height: 20),
                  const Text('Thông tin vận chuyển',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Người đặt hàng: ${order.user!.fullname}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Text("Địa chỉ: ${order.user!.address}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Text("SĐT: ${order.user!.phone}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phương thức thanh toán: ${order.paymentType}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Text("Trạng thái thanh toán:  ${order.paymentStatus}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Text("Trạng thái đơn hàng: ${order.orderStatus}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (order.orderStatus == 'Đã đặt hàng')
                    ElevatedButton(
                      onPressed: () {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          title: 'Hủy đơn hàng',
                          text: 'Bạn có chắc muốn hủy đơn hàng không?',
                          confirmBtnText: 'Hủy đơn hàng',
                          cancelBtnText: 'Quay lại',
                          confirmBtnColor: Colors.red,
                          onConfirmBtnTap: () {
                            orderController.cancelOrder(order.sId!);
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        'Hủy đơn hàng',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrderStatusTimeline(
      String? orderStatus, String? updatedAt, String? createdAt) {
    print('Order status: $orderStatus');
    print('Created at: $createdAt');
    print('Updated at: $updatedAt');

    if (orderStatus == 'Đã hủy') {
      return Center(
        child: SizedBox(
          width: 320,
          child: Image.asset(
            '${AppUrl.imageUrl}Order/cancled_order.png',
          ),
        ),
      );
    }

    final statuses = [
      {'status': 'Đã đặt hàng', 'date': createdAt, 'isCompleted': true},
      {
        'status': 'Đang xử lý',
        'date': updatedAt,
        'isCompleted': orderStatus == 'Đang xử lý'
      },
      {
        'status': 'Đã giao hàng',
        'date': updatedAt,
        'isCompleted': orderStatus == 'Đã giao'
      },
    ];

    if (orderStatus == 'Đã giao') {
      statuses.elementAt(1)['isCompleted'] = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statuses.map((status) {
        return TimelineTile(
          alignment: TimelineAlign.start,
          isFirst: status == statuses.first,
          isLast: status == statuses.last,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: status['isCompleted'] == true ? Colors.purple : Colors.grey,
            iconStyle: status['isCompleted'] == true
                ? IconStyle(
                    iconData: Icons.check,
                    color: Colors.white,
                  )
                : null,
          ),
          endChild: Container(
            constraints: const BoxConstraints(minHeight: 80),
            margin: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status['status'].toString(),
                      style: TextStyle(
                        color: status['isCompleted'] == true
                            ? Colors.black
                            : Colors.grey,
                        fontWeight: status['isCompleted'] == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(status['date'].toString())),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          beforeLineStyle: LineStyle(
            color: status['isCompleted'] == true ? Colors.purple : Colors.grey,
            thickness: 2,
          ),
          afterLineStyle: LineStyle(
            color: status['isCompleted'] == true ? Colors.purple : Colors.grey,
            thickness: 2,
          ),
        );
      }).toList(),
    );
  }
}
