import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Cart/Views/cart_view.dart';
import 'package:techshop_app/module/Category/Controller/category_controller.dart';
import 'package:techshop_app/module/Category/Views/category_view.dart';
import 'package:techshop_app/module/Home/View/home_view.dart'; // Adjust the import if needed

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final CategoryController _categoryController = Get.put(CategoryController());
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    const CategoryView(),
    CartPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      // Category tab index
      _categoryController
          .getCategories(); // Refresh categories when tab is selected
    }
  }

  @override
  void initState() {
    super.initState();
    _categoryController.getCategories(); // Fetch categories when tab loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: CategoryList(), // Use the CategoryList widget here
    );
  }
}
