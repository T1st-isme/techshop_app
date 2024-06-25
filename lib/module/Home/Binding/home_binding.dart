import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Brand/Controller/brand_controller.dart';
import 'package:techshop_app/module/Category/Controller/category_controller.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<BrandController>(() => BrandController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
