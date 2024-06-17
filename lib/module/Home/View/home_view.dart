import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Auth/Views/login_view.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
              Get.to(() => LoginPage());
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          if (authController.user.value != null) {
            return Text('Welcome, ${authController.user.value!.email}');
          } else {
            return const Text('Please login');
          }
        }),
      ),
    );
  }
}
