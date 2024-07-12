import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Cart/Controller/cart_controller.dart';
import 'package:techshop_app/module/Category/Views/category_view.dart';
import 'package:techshop_app/module/Home/View/home_view.dart';
import 'package:techshop_app/module/Order/Views/order_list_view.dart';
import 'package:techshop_app/module/Product/Views/productList_view.dart';
import 'package:techshop_app/module/Profile/Views/profile_view.dart';
import 'package:techshop_app/module/Brand/Controller/brand_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final CartController cartController = Get.find<CartController>();
  final BrandController brandController = Get.find<BrandController>();

  int _currentIndex = 0;
  String? _selectedBrand;

  final List<Widget> _children = [
    const HomePage(),
    const CategoryList(),
    const OrderListView(),
    const ProfileView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    cartController.getCartItemCount();
    brandController.getTopBrands(); // Fetch brands when initializing
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Get.toNamed('/cart');
                  },
                ),
                Positioned(
                  right: 7,
                  top: 7,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      cartController.totalItems.toString(), // Count item in cart
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                child: Image(
                  image: AssetImage('assets/images/TechLogo.png'),
                  fit: BoxFit.contain,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Trang chủ'),
                onTap: () {
                  onTabTapped(0);
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Danh mục'),
                onTap: () {
                  onTabTapped(1);
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Đơn hàng'),
                onTap: () {
                  onTabTapped(2);
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Tôi'),
                onTap: () {
                  onTabTapped(3);
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _children,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color.fromARGB(255, 162, 95, 230),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Danh mục',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Đơn hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Tôi',
            ),
          ],
        ),
      ),
    );
  }
}
