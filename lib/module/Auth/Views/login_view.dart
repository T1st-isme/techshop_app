import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techshop_app/module/Auth/Controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = ValueNotifier<bool>(false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFF1D182A),
            child: Stack(
              children: [
                Positioned(
                  left: 57,
                  top: 21,
                  child: Container(
                    width: 275,
                    height: 275,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://s3-alpha-sig.figma.com/img/23a2/4e73/37adc2e81224c11f88e1f932042f1b68?Expires=1719792000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Tg3IocJ2X6hCNFp9KlHgnXQed4aYVYMnSgApGeaCsHeoR8o1-Zyw2WgS6UrGZMLhRCwpCxfoU~UVU48JbxkzxPT3-lAfiOH05nILwZwDNAatetJo7sy0eZpcjVVlo-EBul97GBFjc8EW4ynQLv9mS-Klqh36HuIjFWjyVPelSFiMc8npprqJVN1I6rAzUcBs9OqMiTh~vKJlmNsRVQEmP3YFFNDhEI4CtuozDV0N2V9y~QNmsZO2A7nmbISaXSaamg9knqzBjv56gtclZFzgpnMrhBk9p~pTizEDeguBbGdQht1ASQ8SdrjTrz34aSoX2mM1LgpamYcipxc0OKw5Uw__"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 27,
                  top: 326,
                  child: Container(
                    width: 340,
                    height: 128,
                    child: Column(
                      children: [
                        Container(
                          width: 340,
                          height: 56,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color(0x268E6CEE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xFF4E4E4E),
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF4E4E4E),
                              fontSize: 16,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 340,
                          height: 56,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color(0x268E6CEE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            decoration: const InputDecoration(
                              labelText: 'Mật khẩu',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xFF4E4E4E),
                              ),
                            ),
                            obscureText: true,
                            style: const TextStyle(
                              color: Color(0xFF4E4E4E),
                              fontSize: 16,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 37,
                  top: 466,
                  child: Container(
                    width: 320,
                    height: 17,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Opacity(
                              opacity: 0.80,
                              child: Container(
                                width: 11.41,
                                height: 11.41,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(2.85),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Ghi nhớ đăng nhập',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Quên mật khẩu',
                          style: TextStyle(
                            color: Color(0xFF8E6CEE),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 80,
                  top: 506,
                  child: Container(
                    height: 95,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: loading.value
                              ? null
                              : () async {
                                  loading.value = true;
                                  bool success = await authController.login(
                                      emailController.text, passwordController.text);
                                  loading.value = false;
                                  if (success) {
                                    Get.toNamed('/home');
                                  } else {
                                    // Xử lý thông báo lỗi nếu cần thiết
                                    Get.snackbar('Đăng nhập thất bại', 'Email hoặc mật khẩu không chính xác');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8E6CEE), // Background color
                            foregroundColor: Colors.white, // Text color
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: const Text('Đăng nhập'), // Text inside the button
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Bạn không có tài khoản?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 4.75),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/register');
                                },
                                child: const Text(
                                  'Đăng ký',
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
