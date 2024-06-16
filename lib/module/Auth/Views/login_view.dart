import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';
import 'package:techshop_app/module/Auth/Views/register_view.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
              onPressed: () {
                authController.login(
                    emailController.text, passwordController.text);
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => RegisterPage());
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
