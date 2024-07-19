// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

// 🌎 Project imports:
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final ProductController _productController = Get.find<ProductController>();
  final FloatingSearchBarController _searchBarController =
      FloatingSearchBarController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productController.fetchProducts(keyword: '', isSearchFetch: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Obx(() {
              if (_productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final results = _productController.productItems
                  .where((product) => product.name!
                      .toLowerCase()
                      .contains(_searchBarController.query.toLowerCase()))
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.only(top: 110),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final product = results[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: product.proImg!.first.img!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name!),
                    onTap: () {
                      Get.toNamed(Routes.PRODUCTDETAIL,
                          parameters: {'slug': product.slug!});
                    },
                  );
                },
              );
            }),
          ),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    return FloatingSearchBar(
      controller: _searchBarController,
      hint: 'Tìm kiếm sản phẩm',
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      backgroundColor: Colors.white,
      iconColor: Colors.black,
      borderRadius: BorderRadius.circular(15),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: const ScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: 600,
      debounceDelay: const Duration(milliseconds: 100),
      onQueryChanged: (query) {
        _productController.fetchProducts(keyword: query, isSearchFetch: true);
      },
      onSubmitted: (query) {
        _productController.fetchProducts(
          keyword: query,
          isSearchFetch: true,
        );
        Get.toNamed(Routes.PRODUCT, arguments: {'keyword': query});
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            elevation: 3.0,
            child: Obx(() {
              if (_productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final suggestions = _productController.productItems
                  .where((product) => product.name!
                      .toLowerCase()
                      .contains(_searchBarController.query.toLowerCase()))
                  .toList();

              if (suggestions.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text('Không có sản phẩm nào.',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 15),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final product = suggestions[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: product.proImg!.first.img!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name!,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black)),
                    onTap: () {
                      Get.toNamed(Routes.PRODUCTDETAIL,
                          parameters: {'slug': product.slug!});
                    },
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}
