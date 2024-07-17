// 🎯 Dart imports:
import 'dart:convert';
import 'dart:math';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

// 🌎 Project imports:
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Brand/Views/brand_view.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';
import '../../../models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = Get.put(AuthController());
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  final List<String> categories = [
    '6552ee08ea3b4606a040af7a',
    '6552ee08ea3b4606a040af7b',
    '6552ee08ea3b4606a040af7c',
    '6552ee08ea3b4606a040af7d',
  ];
  final List<String> carouselImages = [
    'assets/images/BannerAsus.jpg',
    'assets/images/BannerLogi.png',
    'assets/images/BannerRazer.png',
    'assets/images/BannerAkko.jpg',
  ];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    for (var category in categories) {
      await productController.fetchProductsByCategory(category);
    }
  }

  Future<void> _refresh() async {
    if (productController.isLoading.value) {
      await Future.delayed(const Duration(seconds: 30), () {
        _loadData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _retrieveUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          // appBar: _buildAppBar(),
          body: Obx(
            () {
              if (productController.productsByCategory.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(seconds: 2),
                          viewportFraction: 0.8,
                        ),
                        items: carouselImages.map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.PRODUCT);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: AssetImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 40.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Thương hiệu',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      BrandView(),
                      ...categories.map(
                        (category) {
                          final products =
                              productController.productsByCategory[category] ??
                                  [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  category == '6552ee08ea3b4606a040af7a'
                                      ? 'Laptop'
                                      : category == '6552ee08ea3b4606a040af7b'
                                          ? 'Chuột'
                                          : category ==
                                                  '6552ee08ea3b4606a040af7c'
                                              ? 'Bàn phím'
                                              : 'Màn hình',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                height: 220,
                                child: _buildProductList(products),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // AppBar _buildAppBar() {
  //   return AppBar(
  //     title: const Text('Home'),
  //     automaticallyImplyLeading: false,
  //     actions: [
  //       IconButton(
  //         icon: const Icon(Icons.logout),
  //         onPressed: () {
  //           authController.logout();
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildProductList(List<Products> products) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: min(5, products.length) + 1,
      itemBuilder: (context, index) {
        if (index >= min(5, products.length)) {
          return _buildShowMoreButton();
        }
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
        // // Debugging
        // print('Product tapped: ${product.name}');
        // print('Product slug: ${product.slug}');
        // print('Product images: ${product.proImg}');
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
                // width: double.infinity,
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
                      ' $formatPrice₫',
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

  Widget _buildShowMoreButton() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: InkWell(
          onTap: () => Get.toNamed(Routes.PRODUCT),
          child: const Center(
            child: Text(
              "Xem thêm",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _retrieveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final user = User.fromJson(jsonDecode(userData));
      authController.user.user!.value = user;
      return 'Success';
    }
    return null;
  }
}
