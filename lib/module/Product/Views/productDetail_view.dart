// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    //get product detail
    final String? slug = Get.parameters['slug'];
    if (slug == null) {
      return const Center(child: CircularProgressIndicator());
    }
    productController.fetchProductById(slug);

    return Obx(() {
      if (productController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // ignore: invalid_use_of_protected_member
      final Products product = productController.productItems.value
          .firstWhere((product) => product.slug == slug);

      //price format
      final formatter = NumberFormat('#,###', 'vi_VN');
      final value = product.price!.$numberDecimal!;
      final formatPrice = formatter.format(double.parse(value) * 1000000);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Detail'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.proImg?.elementAt(0).img ?? ''),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  product.name!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$formatPrice \u20ab',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  product.description!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
