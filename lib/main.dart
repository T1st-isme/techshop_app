import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Binding/auth_binding.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Auth/Views/login_view.dart';
import 'package:techshop_app/module/Home/View/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TechShop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: AuthBinding(),
      home: Obx(() {
        final AuthController authController = Get.find<AuthController>();
        if (authController.user.value != null) {
          return HomePage();
        } else {
          return LoginPage();
        }
      }),
    );
  }
}
