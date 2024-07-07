import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Auth/Views/check_login_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    authController.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (authController.status.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!authController.isLoggedIn) {
          return const CheckLoginView();
        }
        final user = authController.user;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              user.user?.fullname ?? 'Lỗi tên',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      CachedNetworkImageProvider(user.user?.avatar ?? ''),
                ),
                const SizedBox(height: 10),
                Text(user.user?.email ?? 'Lỗi email'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.UPDATEPROFILE);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 162, 95, 230),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildSectionTitle('Đơn mua'),
                buildOrderSection(),
                const SizedBox(height: 20),
                buildSectionTitle('Tiện ích'),
                buildUtilitySection(),
                const SizedBox(height: 20),
                buildSettingsSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildOrderSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildOrderItem(Icons.pending, 'Chờ xác nhận'),
          buildOrderItem(Icons.local_shipping, 'Chờ giao hàng'),
          buildOrderItem(Icons.history, 'Lịch sử mua hàng'),
        ],
      ),
    );
  }

  Widget buildOrderItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget buildUtilitySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildUtilityItem(Icons.favorite, 'Yêu thích'),
          buildUtilityItem(Icons.notifications, 'Thông báo'),
        ],
      ),
    );
  }

  Widget buildUtilityItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget buildSettingsSection() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            leading: const Icon(Icons.settings, size: 30),
            title: const Text('Cài đặt', style: TextStyle(fontSize: 20)),
            onTap: () {
              // Handle settings
            },
          ),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            leading: const Icon(Icons.help_center, size: 30),
            title:
                const Text('Trung tâm hỗ trợ', style: TextStyle(fontSize: 20)),
            onTap: () {
              // Handle support center
            },
          ),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            leading: const Icon(Icons.logout, size: 30),
            title: const Text('Đăng xuất', style: TextStyle(fontSize: 20)),
            onTap: () {
              authController.logout();
            },
          ),
        ),
      ],
    );
  }
}
