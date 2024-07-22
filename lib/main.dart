// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

// 🌎 Project imports:
import 'package:techshop_app/Core/Theme/app_theme.dart';
import 'package:techshop_app/module/Auth/Binding/auth_binding.dart';
import 'Routes/app_pages.dart';

void main() async {
  // Get.put(CacheService());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        if (link.contains('order-success')) {
          Get.toNamed(Routes.ORDER_SUCCESS);
        } else if (link.contains('order-failed')) {
          Get.toNamed(Routes.ORDER_FAIL);
        }
      }
    }, onError: (err) {
      print('Failed to handle deep link: $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TechShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: MyAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      getPages: AppPages.routes,
      initialBinding: AuthBinding(),
      initialRoute: Routes.SPLASH,
    );
  }
}
