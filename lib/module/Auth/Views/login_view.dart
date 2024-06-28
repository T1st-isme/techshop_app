import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = ValueNotifier<bool>(false);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Login Page'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loading.value
                      ? null
                      : () async {
                          loading.value = true;
                          bool success = await authController.login(
                              emailController.text, passwordController.text);
                          loading.value = false;
                          if (success) {
                            Get.toNamed('/');
                          }
                        },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/register');
                  },
                  child: const Text('Register'),
                ),
              ],
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
}
