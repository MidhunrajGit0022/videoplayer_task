import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/authentication_controller.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/signin_controller.dart';
import 'package:videoplayer/themes/theme_controller.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  final logincontroller = Get.put(LoginController());
  final authcontroller = Get.put(AuthenticationController());
  final theme = Get.put(ThemeController());
  final obscureText = true.obs;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          leading: const Icon(Icons.menu),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            Obx(() => MaterialButton(
                  onPressed: theme.toggleTheme,
                  child: Icon(theme.isDarkMode.value
                      ? Icons.wb_sunny
                      : Icons.nights_stay),
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenSize.height * 0.1),
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: screenSize.height * 0.01),
                        TextField(
                          controller: logincontroller.email,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Text("Password",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: screenSize.height * 0.01),
                        Obx(
                          () => TextField(
                            controller: logincontroller.password,
                            cursorColor: Theme.of(context).colorScheme.primary,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            obscureText: obscureText.value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText.value = !obscureText.value;
                                  });
                                },
                                icon: Icon(
                                  obscureText.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.06),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            logincontroller.loginUser();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 40),
                          ),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('/signup');
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
