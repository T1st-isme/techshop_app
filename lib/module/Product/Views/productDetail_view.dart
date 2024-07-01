// ignore_for_file: file_names, invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  bool _isExpanded = false;
  final String? slug = Get.parameters['slug'];
  @override
  void initState() {
    super.initState();
    productController.fetchProductBySlug(slug!);
  }

  @override
  Widget build(BuildContext context) {
    //get product detail
    if (slug == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Obx(() {
      if (productController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      //get product detail by slug from productList
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
              CachedNetworkImage(
                imageUrl: product.proImg?.elementAt(0).img ?? 'N/A',
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
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
                  _isExpanded
                      ? product.description!
                      : product.description!.length > 100
                          ? '${product.description!.substring(0, 100)}...'
                          : product.description!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                child: Text(_isExpanded ? "Thu gọn" : "Xem thêm"),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  //add product to cart
                  cartController.addToCart([
                    {'product': product.sId, 'quantity': 1}
                  ]);
                },
                child: const Text('Add to cart'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
