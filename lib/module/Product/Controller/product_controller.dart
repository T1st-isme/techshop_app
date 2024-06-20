import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/services/API/ApiException.dart';
import 'package:techshop_app/services/Product/product_service.dart';

class ProductController extends GetxController with StateMixin<List<Products>> {
  var currentPage = 1.obs;
  var productItems = List<Products>.empty(growable: true).obs;
  var isLoading = false.obs;
  var hasMore = true.obs;
  final _productService = ProductService();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    if (!hasMore.value) return;
    isLoading.value = true;
    try {
      final response = await _productService.getProducts(currentPage.value);
      if (response.statusCode == 200) {
        final pro = Product.fromJson(response.data);
        productItems.addAll(pro.products!);
        change(productItems, status: RxStatus.success());
        hasMore.value = pro.products!.isNotEmpty;
      }
      currentPage.value++;
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      change(null, status: RxStatus.error(apiException.toString()));
      if (e.response?.statusCode == 400 &&
          e.response?.data['message'] == 'Invalid page number') {
        hasMore.value = false;
      }
    }
    isLoading.value = false;
  }

  //by slug
  void fetchProductById(String slug) async {
    try {
      final response = await _productService.getProductBySlug(slug);
      if (response.statusCode == 200 && response.data != null) {
        final pro = Products.fromJson(response.data);
        productItems.clear();
        productItems.add(pro);
        change(productItems, status: RxStatus.success());
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      change(null, status: RxStatus.error(apiException.toString()));
    }
  }
}
