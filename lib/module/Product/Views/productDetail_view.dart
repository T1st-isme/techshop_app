// ignore_for_file: file_names, invalid_use_of_protected_member

// 🐦 Flutter imports:
import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:techshop_app/Routes/app_pages.dart';

// 🌎 Project imports:
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';
import 'package:techshop_app/module/WishList/Controller/wish_list_controller.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final WishListController wishListController = Get.find<WishListController>();
  bool _isExpanded = false;
  final String? slug = Get.parameters['slug'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.fetchProductBySlug(slug!);
      wishListController.getWishList();
    });
    // productController.fetchProductBySlug(slug!);
  }

  @override
  Widget build(BuildContext context) {
    //get product detail
    if (slug == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        //arrow back
        leading: IconButton(
          onPressed: () => Get.toNamed(Routes.DASHBOARD),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(
        () {
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          //get product detail by slug from productList
          final Products product = productController.currentProduct.value!;
          // .firstWhere((product) => product.slug == slug);
          final products =
              productController.productsByCategory[product.category?.sId] ?? [];
          // final product = productController.currentProduct;

          // Check if product is in wishlist
          final isInWishlist = wishListController.isInWishlist;
          print("isInWishlist: $isInWishlist");
          //price format
          final formatter = NumberFormat('#,###', 'vi_VN');
          final value = product.price!.$numberDecimal!;
          final formatPrice = formatter.format(double.parse(value) * 1000000);

          return SingleChildScrollView(
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
                    product.name ?? 'N/A',
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
                        ? product.description ?? 'N/A'
                        : product.description != null &&
                                product.description!.length > 100
                            ? '${product.description!.substring(0, 100)}...'
                            : product.description ?? 'N/A',
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
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: product.stock == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Hết hàng',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: () {
                                if (wishListController.wishList.any((item) =>
                                    item.product!.sId == product.sId)) {
                                  wishListController
                                      .removeFromWishList(product.sId ?? 'N/A');
                                } else {
                                  wishListController
                                      .addToWishList(product.sId ?? 'N/A');
                                }
                              },
                              icon: FaIcon(
                                wishListController.wishList.any((item) =>
                                        item.product!.sId == product.sId)
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                cartController.addToCart([
                                  {
                                    'product': product.sId ?? 'N/A',
                                    'quantity': 1
                                  }
                                ]);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 162, 95, 230),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 20.0),
                              ),
                              child: const Text(
                                'Thêm vào giỏ hàng',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (wishListController.wishList.any((item) =>
                                    item.product!.sId == product.sId)) {
                                  wishListController
                                      .removeFromWishList(product.sId ?? 'N/A');
                                } else {
                                  wishListController
                                      .addToWishList(product.sId ?? 'N/A');
                                }
                              },
                              icon: FaIcon(
                                wishListController.wishList.any((item) =>
                                        item.product!.sId == product.sId)
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                ),
                //related products
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'Sản phẩm liên quan',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // productController.relatedProducts.map((product) {
                //   return ProductCard(product: product);
                // }).toList(),
                SizedBox(
                  height: 1000,
                  child: _buildProductList(products),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => Get.toNamed('/product', arguments: {
                      'category': product.category?.sId.toString()
                    }),
                    child: const Text(
                      "Xem thêm",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductList(List<Products> products) {
    // return ListView.builder(
    //   scrollDirection: Axis.horizontal,
    //   padding: const EdgeInsets.symmetric(horizontal: 16),
    //   itemCount: min(5, products.length) + 1,
    //   itemBuilder: (context, index) {
    //     if(index >= min(5, products.length)) {
    //       return _buildShowMoreButton();
    //     }
    //     return _buildProductCard(products[index]);
    //   }
    // );
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: min(8, products.length) + 1,
      itemBuilder: (context, index) {
        // if (index >= min(8, products.length)) {
        //     return _buildShowMoreButton();
        // }
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(Products product) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    final value = product.price!.$numberDecimal!;
    final formatPrice = formatter.format(double.parse(value) * 1000000);
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.PRODUCTDETAIL, parameters: {'slug': product.slug!});
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 4),
        child: Card(
          color: Colors.grey.shade200,
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: product.proImg?.elementAt(0).img ?? '',
                  errorWidget: (context, url, error) => const Icon(
                    FluentIcons.image_off_20_filled,
                  ),
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade400,
                      child: Container(
                        height: 100,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$formatPrice₫',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 162, 95, 230),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  product.stock == 0
                      ? const Text(
                          'Hết hàng',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            cartController.addToCart([
                              {'product': product.sId, 'quantity': 1}
                            ]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 162, 95, 230),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.cartPlus,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
