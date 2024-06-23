import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Binding/auth_binding.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Auth/Views/login_view.dart';
import 'package:techshop_app/module/Auth/Views/register_view.dart';
import 'package:techshop_app/module/Category/Binding/category_binding.dart';
import 'package:techshop_app/module/Home/View/home_view.dart';
import 'package:techshop_app/module/Product/Binding/product_binding.dart';
import 'package:techshop_app/module/Product/Views/productDetail_view.dart';
import 'package:techshop_app/module/Product/Views/productList_view.dart';

import 'module/Category/Views/category_view.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TechShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Obx(() {
        final AuthController authController = Get.find<AuthController>();
        if (authController.user.value != null) {
          return HomePage();
        } else {
          return LoginPage();
        }
      }),
      initialBinding: AuthBinding(),
      initialRoute: '/home',
      getPages: [
        GetPage(
            name: '/login', page: () => LoginPage(), binding: AuthBinding()),
        GetPage(name: '/home', page: () => HomePage(), binding: AuthBinding()),
        GetPage(
            name: '/register',
            page: () => RegisterPage(),
            binding: AuthBinding()),
        GetPage(
            name: '/product/detail',
            page: () => const ProductDetailView(),
            binding: ProductBinding()),
        GetPage(
            name: '/product',
            page: () => ProductListPage(),
            binding: ProductBinding()),
        GetPage(
            name: '/category',
            page: () => CategoryList(),
            binding: CategoryBinding()),
      ],
    );
  }
}
