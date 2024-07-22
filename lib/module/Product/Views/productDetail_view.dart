// ignore_for_file: file_names, invalid_use_of_protected_member

// 🐦 Flutter imports:
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
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
          final List<String> carouselImages =
              product.proImg?.map((image) => image.img ?? 'N/A').toList() ?? [];

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
                if (carouselImages.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      // autoPlay: true,
                      // aspectRatio: 16 / 9,
                      // autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      // autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
                    ),
                    items: carouselImages.map((imageURL) {
                      return Builder(builder: (BuildContext context) {
                        return CachedNetworkImage(
                          imageUrl: imageURL,
                          errorWidget: (context, url, error) => const Icon(
                            FluentIcons.image_off_20_filled,
                          ),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.grey.shade400,
                              child: Container(
                                height: 400,
                                width: 400,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
                if (_isExpanded) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Thông số kỹ thuật',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (product.category?.sId == '6552ee08ea3b4606a040af7b') ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Tần suất'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.tansuat ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Bộ vi xử lý'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.bovixuly ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Pin'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.pin ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cảm biến'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.cambien ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Màu'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.mau ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Độ phân giải'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.dophangiai ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Trọng lượng'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.trongluong ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Kích thước'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.kichthuoc ?? 'N/A'),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  }
                  // Màn hình
                  else if (product.category?.sId ==
                      '6552ee08ea3b4606a040af7d') ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Kích thước màn hình'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.kichthuocmanhinh ??
                                      'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Tỷ lệ'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.tyle ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Khu vực hiển thị'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.khuvuchienthi ??
                                      'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Loại màn hình'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.loaimanhinh ??
                                      'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Tấm nền'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.tamnen ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Góc nhìn'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.gocnhin ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Độ phân giải'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.dophangiai ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Độ sáng'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.dosang ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Màu sắc hiển thị'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.mausachienthi ??
                                      'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Tần số quét'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.tansoquet ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cổng giao tiếp'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.conggiaotiep ??
                                      'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Điện năng'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.dienang ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Kích thước'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.kichthuoc ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Phụ kiện'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.phukien ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Trọng lượng'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.trongluong ?? 'N/A'),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  }
                  // Bàn phím
                  else if (product.category?.sId ==
                      '6552ee08ea3b4606a040af7c') ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Tỷ lệ bàn phím'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.size ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Kết nối'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.connect ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Keycap'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.keycap ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Công tắc'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.congtac ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Led'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.led ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Hỗ trợ'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.support ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Phụ kiện'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.phukien ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Kích thước'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.kichthuoc ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Trọng lượng'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.trongluong ?? 'N/A'),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  }
                  // Laptop
                  else if (product.category?.sId ==
                      '6552ee08ea3b4606a040af7a') ...{
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('CPU'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.cpu ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('VGA'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.vga ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Màn hình'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  product.richdescription?.display ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Ram'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.ram ?? 'N/A'),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('SSD'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(product.richdescription?.ssd ?? 'N/A'),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  }
                ],
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
