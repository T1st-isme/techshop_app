import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Brand/Views/brand_view.dart';
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

  @override
  void initState() {
    super.initState();
    productController.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _retrieveUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Home'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            authController.logout();
            Get.toNamed('/login');
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandView(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Welcome, ${authController.user.user?.email ?? 'Unknown'}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Featured Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220, // Fixed height for the product list container
          child: _buildProductList(),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Obx(() {
      if (productController.productItems.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: min(5, productController.productItems.length) + 1,
        itemBuilder: (context, index) {
          if (index >= min(5, productController.productItems.length)) {
            return _buildShowMoreButton();
          }
          return _buildProductCard(index);
        },
      );
    });
  }

  Widget _buildProductCard(int index) {
    final product = productController.productItems[index];
    return GestureDetector(
      onTap: () =>
          Get.toNamed('/product/detail', parameters: {'slug': product.slug!}),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120, // Fixed height for the image
                width: double.infinity,
                child: Image.network(
                  product.proImg![0].img!,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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
          onTap: () => Get.toNamed('/product'),
          child: const Center(
            child: Text(
              "Show More",
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
