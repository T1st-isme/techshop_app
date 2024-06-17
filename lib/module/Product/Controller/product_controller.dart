import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/services/API/ApiException.dart';
import 'package:techshop_app/services/Product/product_service.dart';

class ProductController extends GetxController with StateMixin<List<Products>> {
  var productItems = <Products>[].obs; // Changed to hold ProductItem instances
  var currentPage = 1.obs;
  // var hasMore = true.obs;

  final ProductService _productService = Get.find<ProductService>();
  // final int expectedPageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final response = await _productService.getProducts();
      log("data $response");

      if (response.statusCode == 200) {
        final pro = Product.fromJson(response.data);
        productItems.assignAll(pro.products!);
        change(productItems,
            status: RxStatus.success()); // Added the change method
      }
      currentPage.value++;
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      change(null, status: RxStatus.error(apiException.toString()));
    }
  }
}
