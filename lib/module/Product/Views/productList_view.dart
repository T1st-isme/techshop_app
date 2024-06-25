// ignore_for_file: file_names, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/module/Category/Views/category_view.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductController _productController = Get.find<ProductController>();
  final ScrollController _scrollController = Get.put(ScrollController());
  final Map<String, String?> data = Get.arguments ?? {};
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        _productController.fetchProducts(
            category: data['category'], brand: data['brand']);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: GetBuilder<ProductController>(
        init: _productController,
        initState: (_) {
          _productController.fetchProducts(
              category: data['category'], brand: data['brand']);
        },
        builder: (_) {
          if (_productController.productItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_productController.productItems.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                // padding: const EdgeInsets.all(8),
                child: Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  // child: CategoryList(),
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == _productController.productItems.length &&
                        _productController.isLoading.value &&
                        _productController.hasMore == true) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (index == _productController.productItems.length - 1 &&
                          !_productController.isLoading.value) {
                        Future.microtask(
                          () => _productController.fetchProducts(
                            category: Get.arguments,
                          ),
                        );
                      }
                      final productItem =
                          _productController.productItems[index];
                      return itemGridView(productItem);
                    }
                  },
                  childCount: _productController.productItems.length +
                      (_productController.isLoading.value ? 1 : 0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget itemGridView(Products proItem) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  final value = proItem.price!.$numberDecimal!;
  final formatPrice = formatter.format(double.parse(value) * 1000000);
  return GestureDetector(
    onTap: () => {
      Get.toNamed('/product/detail', parameters: {'slug': proItem.slug!})
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network(
            proItem.proImg?.elementAt(0).img ?? 'N/A',
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image),
          ),
          Text(
            proItem.name ?? 'N/A',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            proItem.brand ?? 'N/A',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Text(' $formatPrice \u20ab',
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
