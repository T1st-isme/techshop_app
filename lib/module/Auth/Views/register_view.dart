import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullnameController,
              decoration: const InputDecoration(labelText: 'Fullname'),
            ),
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
                authController.register(fullnameController.text,
                    emailController.text, passwordController.text);
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
