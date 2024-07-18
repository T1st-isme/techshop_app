// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

// 🌎 Project imports:
import 'package:techshop_app/models/wishList.dart';
import 'package:techshop_app/services/API/ApiException.dart';
import 'package:techshop_app/services/WishList/wish_list_service.dart';

class WishListController extends GetxController {
  final WishListService _wishListService = WishListService();
  RxList<WishListItems> wishList = RxList<WishListItems>();
  Rx<RxStatus> status = Rx<RxStatus>(RxStatus.empty());
  var isInWishlist = false;

  Future<void> getWishList() async {
    status.value = RxStatus.loading();
    try {
      final response = await _wishListService.getWishList();
      if (response.statusCode == 200) {
        if (response.data is Map && response.data['wishList'] != null) {
          final wishListData = WishList.fromJson(response.data['wishList']);
          wishList.value = wishListData.wishListItems ?? [];
          isInWishlist = true;
        } else if (response.data is List) {
          wishList.value = response.data
              .map((item) => WishListItems.fromJson(item))
              .toList();
        } else {
          wishList.clear();
        }
        status.value = RxStatus.success();
      } else {
        status.value = RxStatus.error('Lỗi');
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioException(e);
      status.value = RxStatus.error(apiException.toString());
    }
    update();
  }

  Future<void> removeFromWishList(String productId) async {
    status.value = RxStatus.loading();
    try {
      await _wishListService.removeFromWishList(productId);
      await getWishList();
      status.value = RxStatus.success();
      isInWishlist = false;
    } catch (e) {
      status.value = RxStatus.error('Lỗi');
    }
    update();
  }

  Future<void> addToWishList(String productId) async {
    status.value = RxStatus.loading();
    try {
      await _wishListService.addToWishList(productId);
      await getWishList();
      status.value = RxStatus.success();
      isInWishlist = true;
    } catch (e) {
      status.value = RxStatus.error('Lỗi');
    }
    update();
  }
}
