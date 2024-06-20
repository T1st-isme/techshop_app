// ignore_for_file: file_names, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';

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
        if (_productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: _productController.productItems.length +
                (_productController.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _productController.productItems.length &&
                  _productController.isLoading.value &&
                  _productController.hasMore == true) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (index == _productController.productItems.length - 1 &&
                    !_productController.isLoading.value) {
                  Future.microtask(() => _productController.fetchProducts());
                }
                final productItem = _productController.productItems[index];
                final formatter = NumberFormat('#,###', 'vi_VN');
                final value = productItem.price!.$numberDecimal!;
                final formatPrice =
                    formatter.format(double.parse(value) * 1000000);

                return ListTile(
                  leading:
                      Image.network(productItem.proImg?.elementAt(0).img ?? ''),
                  title: Text(productItem.name ?? 'N/A'),
                  subtitle: Text(productItem.brand ?? 'N/A'),
                  trailing: Text('$formatPrice \u20ab'),
                  onTap: () => {
                    Get.toNamed('/product/detail',
                        parameters: {'slug': productItem.slug!})
                  },
                );
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
