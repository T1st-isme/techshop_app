import 'package:get/get.dart';
import 'package:techshop_app/module/Brand/Controller/brand_controller.dart';
import 'package:techshop_app/services/Brand/brand_service.dart';

class BrandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrandService>(() => BrandService());
    Get.lazyPut<BrandController>(() => BrandController());
  }
}
