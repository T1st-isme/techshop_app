// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:techshop_app/models/category.dart';
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';
import 'package:techshop_app/module/Category/Controller/category_controller.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductController _productController = Get.find<ProductController>();
  final CategoryController _categoryController = Get.put(CategoryController());
  final ScrollController _scrollController = Get.put(ScrollController());
  final Map<String, String?> data = Get.arguments ?? {};
  bool _isDisposed = false;
  String? _selectedCategoryName;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _scrollController.addListener(() {
      if (!_scrollController.hasClients || _isDisposed) {
        return;
      }

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _productController.fetchProducts(
            category: data['category'], brand: data['brand']);
      }
    });
    _categoryController.getCategories(); // Fetch categories
    if (data['category'] != null) {
      _productController.fetchProducts(
        category: data['category'],
        isCategoryFetch: true,
      );
    }
    if (data['brand'] != null) {
      _productController.fetchProducts(
        brand: data['brand'],
        isBrandFetch: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _productController.fetchAllProducts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (_categoryController.status.value == RxStatus.loading()) {
              return const CircularProgressIndicator(); // Loading
            }
            if (_categoryController.category.value.categoryList == null ||
                _categoryController.category.value.categoryList!.isEmpty) {
              return const Text('No categories found');
            }
            return DropdownButton<String>(
              hint: Text(_selectedCategoryName ?? 'Select a category'),
              items: _categoryController.category.value.categoryList!
                  .map((CategoryList category) {
                return DropdownMenuItem<String>(
                  value: category.sId,
                  child: Text(category.name!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  //Update curr value display dropdown
                  setState(() {
                    _selectedCategoryName = _categoryController
                        .category.value.categoryList!
                        .firstWhere((category) => category.sId == newValue)
                        .name;
                  });
                  _productController.fetchProducts(
                    category: newValue,
                    isCategoryFetch: true,
                  );
                }
              },
            );
          }),
          Expanded(
            child: GetBuilder<ProductController>(
              init: _productController,
              initState: (_) {
                _productController.fetchProducts(
                    category: data['category'], brand: data['brand']);
              },
              builder: (_) {
                if (_productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_productController.productItems.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  controller: _scrollController,
                  itemCount: _productController.productItems.length,
                  itemBuilder: (context, index) {
                    final product = _productController.productItems[index];
                    return itemGridView(product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget itemGridView(Products proItem) {
  final CartController cartController = Get.find<CartController>();
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
          CachedNetworkImage(
            imageUrl: proItem.proImg?.elementAt(0).img ?? 'N/A',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
          Text(' $formatPrice ₫',
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              cartController.addToCart([
                {'product': proItem.sId, 'quantity': 1}
              ]);
            },
            child: const Text('Add to cart'),
          ),
        ],
      ),
    ),
  );
}
