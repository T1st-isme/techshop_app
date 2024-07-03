import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = ValueNotifier<bool>(false);

    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFF1D182A),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        width: 160,
                        height: 160,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://s3-alpha-sig.figma.com/img/23a2/4e73/37adc2e81224c11f88e1f932042f1b68?Expires=1719792000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Tg3IocJ2X6hCNFp9KlHgnXQed4aYVYMnSgApGeaCsHeoR8o1-Zyw2WgS6UrGZMLhRCwpCxfoU~UVU48JbxkzxPT3-lAfiOH05nILwZwDNAatetJo7sy0eZpcjVVlo-EBul97GBFjc8EW4ynQLv9mS-Klqh36HuIjFWjyVPelSFiMc8npprqJVN1I6rAzUcBs9OqMiTh~vKJlmNsRVQEmP3YFFNDhEI4CtuozDV0N2V9y~QNmsZO2A7nmbISaXSaamg9knqzBjv56gtclZFzgpnMrhBk9p~pTizEDeguBbGdQht1ASQ8SdrjTrz34aSoX2mM1LgpamYcipxc0OKw5Uw__"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      buildTextField('Email', emailController, Icons.email),
                      const SizedBox(height: 16),
                      buildTextField('Số điện thoại', fullnameController, Icons.phone),
                      const SizedBox(height: 16),
                      buildTextField('Mật khẩu', passwordController, Icons.lock, obscureText: true),
                      const SizedBox(height: 16),
                      buildTextField('Nhập lại mật khẩu', confirmPasswordController, Icons.lock, obscureText: true),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          authController.register(fullnameController.text, emailController.text, passwordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E6CEE), // Màu nền của nút
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white, // Màu chữ
                          ),
                        ),
                        child: const Text('Tạo tài khoản', style: TextStyle(color: Colors.white)), // Chữ màu trắng
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Bạn đã có tài khoản!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 4.75),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                color: Color(0xFFFFC42A),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const ModalBarrier(dismissible: false, color: Colors.black45);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller, IconData icon, {bool obscureText = false}) {
    return Container(
      width: double.infinity,
      height: 56,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0x268E6CEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF4E4E4E),
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF4E4E4E),
          fontSize: 16,
          fontFamily: 'Arial',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
