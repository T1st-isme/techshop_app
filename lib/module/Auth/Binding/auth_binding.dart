import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/services/API/ApiService.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(Dio()));
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
