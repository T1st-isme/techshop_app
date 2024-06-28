import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Brand/Views/brand_view.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';
import '../../../models/user.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    return FutureBuilder<String?>(
      future: _retrieveUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
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
            ),
            body: Center(
              child: FutureBuilder<String?>(
                future: authController.getToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        BrandView(),
                        const SizedBox(height: 50),
                        Text(
                            'Welcome, ${authController.user.user?.email ?? 'Unknown'}'),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                min(5, productController.productItems.length) +
                                    1,
                            itemBuilder: (context, index) {
                              if (index >=
                                  min(5,
                                      productController.productItems.length)) {
                                return TextButton(
                                  child: const Text("Show More"),
                                  onPressed: () {
                                    Get.toNamed('/product');
                                  },
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      '/product/detail',
                                      parameters: {
                                        'slug': productController
                                            .productItems[index].slug!
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    height: 150.0,
                                    width: 160.0,
                                    child: Card(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Image.network(
                                              productController
                                                  .productItems[index]
                                                  .proImg![0]
                                                  .img!,
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(productController
                                                .productItems[index].name!),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        }
      },
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
