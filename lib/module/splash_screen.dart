import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/constants/AppUrl.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(Routes.DASHBOARD);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '${AppUrl.imageUrl}TechLogo2.png', // Đảm bảo rằng bạn đã thêm logo vào thư mục assets
              width: 300, // Thay đổi kích thước logo tùy ý
              height: 300,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      ),
    );
  }
}
