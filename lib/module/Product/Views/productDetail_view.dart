import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';

class ProductDetailView extends StatelessWidget {
  final ProductController _productController = Get.find<ProductController>();

  ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${product['description']}'),
            Text('Price: \$${product['price']}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
