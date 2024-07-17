// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:techshop_app/models/product.dart';
import 'package:techshop_app/services/API/ApiException.dart';
import 'package:techshop_app/services/Product/product_service.dart';

class ProductController extends GetxController with StateMixin<List<Products>> {
  var currentPage = 1.obs;
  var productItems = List<Products>.empty(growable: true).obs;
  var isLoading = false.obs;
  var hasMore = true.obs;
  final _productService = ProductService();
  final RxMap<String, List<Products>> productsByCategory =
      <String, List<Products>>{}.obs; // Map to store products by category

  void resetState() {
    currentPage.value = 1;
    isLoading.value = false;
    hasMore.value = true;
    productItems.clear();
    update();
  }

  Future<void> fetchProductsByCategory(String category) async {
    isLoading.value = true;
    hasMore.value = false;
    resetState();
    try {
      final response = await _productService.getProducts(
        currentPage.value,
        category: category,
      );
      if (response.statusCode == 200) {
        final pro = Product.fromJson(response.data);
        productsByCategory[category] = pro.products ?? [];
        hasMore.value = pro.products!.isNotEmpty;
      }
      currentPage.value++;
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      change(null, status: RxStatus.error(apiException.toString()));
      productsByCategory[category] = [];
      if (e.response?.statusCode == 400 &&
          e.response?.data['message'] == 'Invalid page number') {
        hasMore.value = false;
      }
    }
    isLoading.value = false;
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
    int? stock,
    bool isCategoryFetch = false,
    bool isBrandFetch = false,
    bool isStockFetch = false,
    bool isSortFetch = false,
  }) async {
    if (isLoading.value || !hasMore.value) return;
    if (isCategoryFetch || isBrandFetch || isStockFetch || isSortFetch) {
      resetState();
    }
    try {
      isLoading.value = true;
      final response = await _productService.getProducts(
        currentPage.value,
        keyword: keyword,
        resPerPage: resPerPage,
        category: category,
        brand: brand,
        sort: sort,
        stock: stock,
      );
      if (response.statusCode == 200) {
        // final pro = Product.fromJson(response.data);
        // // print("Fetched products: ${pro.products!.length}"); // Debugging line
        // productItems.addAll(pro.products!);
        if (response.data is List) {
          // If response.data is a list, map each item to a Products object
          productItems.addAll((response.data as List)
              .map((item) => Products.fromJson(item))
              .toList());
        } else {
          // If response.data is not a list, handle it as before
          final pro = Product.fromJson(response.data);
          productItems.addAll(pro.products!);
          hasMore.value = pro.products!.isNotEmpty;
        }
        change(productItems, status: RxStatus.success());
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
  var currentProduct = Rxn<Products>();

  Future<void> fetchProductBySlug(String slug) async {
    isLoading.value = true;
    try {
      final response = await _productService.getProductBySlug(slug);
      if (response.statusCode == 200 && response.data != null) {
        final pro = Products.fromJson(response.data['data']);
        currentProduct.value = pro;
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      change(null, status: RxStatus.error(apiException.toString()));
    }
    isLoading.value = false;
    update();
  }

  void fetchRelatedProducts(String category) {
    final relatedProducts = productItems.where((product) {
      return product.category?.sId == category;
    }).toList();
    change(relatedProducts, status: RxStatus.success());
  }
}
