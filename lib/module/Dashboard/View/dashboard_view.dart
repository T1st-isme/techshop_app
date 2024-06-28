import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Cart/Views/cart_view.dart';
import 'package:techshop_app/module/Category/Views/category_view.dart';
import 'package:techshop_app/module/Home/View/home_view.dart';
import 'package:techshop_app/module/Product/Views/productList_view.dart';
import 'package:techshop_app/module/Dashboard/Controller/dashboard_controller.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: dashboardController.animatedToTab,
        controller: dashboardController.pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          HomePage(),
          CategoryList(),
          CartPage(),
          HomePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAppBarItem(
                  context,
                  icon: Icons.home,
                  label: 'Home',
                  page: 0,
                ),
                _bottomAppBarItem(
                  context,
                  icon: Icons.search,
                  label: 'Product',
                  page: 1,
                ),
                _bottomAppBarItem(
                  context,
                  icon: Icons.shopping_cart,
                  label: 'Cart',
                  page: 2,
                ),
                _bottomAppBarItem(
                  context,
                  icon: Icons.person,
                  label: 'Profile',
                  page: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomAppBarItem(BuildContext context,
      {required icon, required label, required page}) {
    return ZoomTapAnimation(
      onTap: () => dashboardController.goToPage(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Icon(
                icon,
                color: dashboardController.currentPage.value == page
                    ? Colors.blue
                    : Colors.grey,
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    color: dashboardController.currentPage.value == page
                        ? Colors.blue
                        : Colors.grey,
                    fontSize: 13,
                    fontWeight: dashboardController.currentPage.value == page
                        ? FontWeight.w600
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Obx(() {
//         final AuthController authController = Get.find<AuthController>();
//         if (authController.user.user != null &&
//             authController.isLoggedIn() == true) {
//           return HomePage();
//         } else {
//           return LoginPage();
//         }