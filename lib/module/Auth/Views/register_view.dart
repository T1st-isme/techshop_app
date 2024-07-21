// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:techshop_app/Routes/app_pages.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isPasswordFocused = ValueNotifier<bool>(false);
  final FocusNode passwordFocusNode = FocusNode();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = ValueNotifier<bool>(false);

    passwordFocusNode.addListener(() {
      _isPasswordFocused.value = passwordFocusNode.hasFocus;
    });

    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(255, 235, 235, 235),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        width: 275,
                        height: 275,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/TechLogo.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      buildTextField(
                          'Họ và tên', fullnameController, Icons.person),
                      const SizedBox(height: 16),
                      buildTextField('Email', emailController, Icons.email),
                      const SizedBox(height: 16),
                      buildTextField(
                          'Số điện thoại', phoneController, Icons.phone),
                      const SizedBox(height: 16),
                      buildTextField('Mật khẩu', passwordController, Icons.lock,
                          obscureText: _obscureText,
                          focusNode: passwordFocusNode),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          loading.value = true;
                          bool success = await authController.register(
                              fullnameController.text,
                              emailController.text,
                              passwordController.text,
                              phoneController.text);
                          loading.value = false;
                          if (success) {
                            Get.toNamed(Routes.DASHBOARD);
                          } else {
                            Get.snackbar(
                                'Registration Failed', 'Please try again.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF8E6CEE), // Màu nền của nút
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white, // Màu chữ
                          ),
                        ),
                        child: const Text('Tạo tài khoản',
                            style: TextStyle(
                                color: Colors.white)), // Chữ màu trắng
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Bạn đã có tài khoản!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
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
              return const ModalBarrier(
                  dismissible: false, color: Colors.black45);
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

  Widget buildTextField(
      String labelText, TextEditingController controller, IconData icon,
      {ValueNotifier<bool>? obscureText, FocusNode? focusNode}) {
    return Container(
      width: double.infinity,
      height: 56,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0x268E6CEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: obscureText ?? ValueNotifier<bool>(false),
        builder: (context, isObscure, child) {
          return TextField(
            controller: controller,
            obscureText: isObscure,
            focusNode: focusNode,
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
              suffixIcon: focusNode != null
                  ? ValueListenableBuilder<bool>(
                      valueListenable: _isPasswordFocused,
                      builder: (context, isFocused, child) {
                        return isFocused
                            ? IconButton(
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF4E4E4E),
                                ),
                                onPressed: () {
                                  obscureText!.value = !obscureText.value;
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            style: const TextStyle(
              color: Color(0xFF4E4E4E),
              fontSize: 16,
              fontFamily: 'Arial',
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }
}
