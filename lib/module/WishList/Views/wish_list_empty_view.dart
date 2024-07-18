// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:techshop_app/Routes/app_pages.dart';

class WishListEmptyView extends StatelessWidget {
  const WishListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Chưa có sản phẩm yêu thích nào',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Icon(Icons.heart_broken, size: 50),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.DASHBOARD);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 162, 95, 230),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: const Text(
              'Chọn sản phẩm yêu thích ngay !!!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
