// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import 'package:techshop_app/module/Auth/Binding/auth_binding.dart';
import 'package:techshop_app/module/Auth/Views/login_view.dart';
import 'package:techshop_app/module/Auth/Views/register_view.dart';
import 'package:techshop_app/module/Brand/Binding/brand_binding.dart';
import 'package:techshop_app/module/Brand/Views/brand_view.dart';
import 'package:techshop_app/module/Cart/Binding/cart_binding.dart';
import 'package:techshop_app/module/Cart/Views/cart_view.dart';
import 'package:techshop_app/module/Category/Binding/category_binding.dart';
import 'package:techshop_app/module/Category/Views/category_view.dart';
import 'package:techshop_app/module/Dashboard/Binding/dashboard_binding.dart';
import 'package:techshop_app/module/Dashboard/View/dashboard_view.dart';
import 'package:techshop_app/module/Home/Binding/home_binding.dart';
import 'package:techshop_app/module/Home/View/home_view.dart';
import 'package:techshop_app/module/Product/Binding/product_binding.dart';
import 'package:techshop_app/module/Product/Views/productDetail_view.dart';
import 'package:techshop_app/module/Product/Views/productList_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
        name: _Paths.PRODUCTDETAIL,
        page: () => const ProductDetailView(),
        binding: ProductBinding()),
    GetPage(
        name: _Paths.PRODUCT,
        page: () => const ProductListPage(),
        binding: ProductBinding()),
    GetPage(
        name: '/category',
        page: () => CategoryList(),
        binding: CategoryBinding()),
    GetPage(
      name: '/brand',
      page: () => BrandView(),
      binding: BrandBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartPage(),
      binding: CartBinding(),
    ),
  ];
}
