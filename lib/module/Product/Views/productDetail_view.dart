// ignore_for_file: file_names, invalid_use_of_protected_member

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
      ),
      body: Obx(
        () {
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          //get product detail by slug from productList
          final Products product = productController.currentProduct.value!;
          // .firstWhere((product) => product.slug == slug);

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
              ],
            ),
          );
        },
      ),
    );
  }
}
