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

  void resetState() {
    currentPage.value = 1;
    isLoading.value = false;
    hasMore.value = true;
    productItems.clear();
    update();
  }

  void fetchAllProducts() async {
    if (isLoading.value) return;
    resetState();
    try {
      final response = await _productService.getProducts(currentPage.value);
      if (response.statusCode == 200) {
        final pro = Product.fromJson(response.data);
        // print(
        //     "Fetched all products: ${pro.products!.length}"); // Debugging line
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
    update();
  }

  void fetchProducts({
    String keyword = "",
    int resPerPage = 12,
    String? category,
    String? brand,
    String? sort,
    bool isCategoryFetch = false, // Add a parameter to indicate category fetch
    bool isBrandFetch = false, // Add a parameter to indicate category fetch
  }) async {
    if (isLoading.value || !hasMore.value) return;
    if (isCategoryFetch) {
      resetState();
    }
    if (isBrandFetch) {
      resetState();
    }
    isLoading.value = true;
    try {
      final response = await _productService.getProducts(
        currentPage.value,
        keyword: keyword,
        resPerPage: resPerPage,
        category: category,
        brand: brand,
        sort: sort,
      );
      if (response.statusCode == 200) {
        final pro = Product.fromJson(response.data);
        // print("Fetched products: ${pro.products!.length}"); // Debugging line
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
    update();
  }

  //by slug
  void fetchProductBySlug(String slug) async {
    try {
      final response = await _productService.getProductBySlug(slug);
      if (response.statusCode == 200 && response.data != null) {
        final pro = Products.fromJson(response.data['data']);
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
