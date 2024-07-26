import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/authentication_controller.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/signup_controller.dart';
import 'package:videoplayer/themes/theme_controller.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({super.key});

  @override
  State<Signup_page> createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  final signupcontroller = Get.put(SignUpController());
  final authcontroller = Get.put(AuthenticationController());
  final theme = Get.put(ThemeController());
  final obscureText = true.obs;
  File? _imageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageBytes = File(pickedImage.path);
        signupcontroller.setImageFile(_imageBytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Registration",
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
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: _imageBytes != null
                                    ? FileImage(_imageBytes!)
                                    : const NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaaNaTC8W_ygKLZxLFWpHOerfIYQiVlsuyrw&s'),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: _pickImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Text("Name",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: screenSize.height * 0.01),
                        TextField(
                          controller: signupcontroller.name,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              filled: true,
                              hintText: 'Name',
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Text(
                          "Date of birth",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        TextField(
                          controller: signupcontroller.dob,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              filled: true,
                              hintText: 'Date of birth',
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          readOnly: true,
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              signupcontroller.dob.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            }
                          },
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Text("Email",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: screenSize.height * 0.01),
                        TextField(
                          controller: signupcontroller.email,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              hintText: 'Email',
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
                            controller: signupcontroller.password,
                            cursorColor: Theme.of(context).colorScheme.primary,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            obscureText: obscureText.value,
                            decoration: InputDecoration(
                              hintText: 'Password',
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
                            // signupcontroller.register();
                            if (signupcontroller.email.text.isNotEmpty) {
                              Get.toNamed(
                                "/otppage",
                                arguments: {
                                  "email": signupcontroller.email.text,
                                  "forgot": false,
                                },
                              );
                            } else {}
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
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 18)),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/login');
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      )
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
