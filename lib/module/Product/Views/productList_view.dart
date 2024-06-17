import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';
import 'package:techshop_app/module/Product/Views/productDetail_view.dart';

class ProductListPage extends StatelessWidget {
  final ProductController _productController = Get.find<ProductController>();

  ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Obx(() {
        if (_productController.productItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: _productController.productItems.length,
            itemBuilder: (context, index) {
              if (index < _productController.productItems.length) {
                final productItem = _productController.productItems[index];
                // final formatter =
                //     NumberFormat.currency(locale: 'vi_VN', symbol: '\u20ab');
                final formatter = NumberFormat('#,###', 'vi_VN');
                final value = productItem.price!.$numberDecimal!;
                final formatPrice =
                    formatter.format(double.parse(value) * 1000000);

                return ListTile(
                  title: Text(productItem.name ?? 'N/A'),
                  subtitle: Text(productItem.brand ?? 'N/A'),
                  trailing: Text('$formatPrice \u20ab'),
                  onTap: () =>
                      Get.to(() => ProductDetailView(), arguments: productItem),
                );
              } else {
                return const SizedBox
                    .shrink(); // Or some other placeholder widget
              }
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() {}),
      ),
    );
  }
}
