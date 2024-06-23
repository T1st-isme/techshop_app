import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Category/Controller/category_controller.dart';
import 'package:techshop_app/module/Product/Controller/product_controller.dart';
import 'package:techshop_app/services/Product/product_service.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());

    Get.lazyPut<ScrollController>(() => ScrollController());

    Get.lazyPut<ProductService>(() => ProductService());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
