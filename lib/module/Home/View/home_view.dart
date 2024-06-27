import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Auth/Views/login_view.dart';
import 'package:techshop_app/module/Brand/Views/brand_view.dart';
import 'package:techshop_app/module/Category/Views/category_view.dart';

import '../../../models/user.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _retrieveUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Home'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authController.logout();
                    Get.toNamed('/login');
                  },
                ),
              ],
            ),
            body: Center(
              child: FutureBuilder<String?>(
                future: authController.getToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      children: [
                        BrandView(),
                        CategoryList(),
                        Text(
                            'Welcome, ${authController.user.user?.email ?? 'Unknown'}'),
                      ],
                    );
                  } else {
                    return const Text('Go login');
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }

  Future<String?> _retrieveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final user = User.fromJson(jsonDecode(userData));
      authController.user.user!.value = user;
      return 'Success';
    }
    return null;
  }
}
