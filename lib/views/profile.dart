import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:videoplayer/controller/user_controller.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/authentication_controller.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/signup_controller.dart';
import 'package:videoplayer/model/user_model.dart';
import 'package:videoplayer/themes/theme_controller.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  final signupcontroller = Get.put(SignUpController());
  final authcontroller = Get.put(AuthenticationController());
  final usercontroller = Get.put(Profilecontroller());
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
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: StreamBuilder<Usermodel>(
              stream: usercontroller.getuserdata(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  Usermodel user = snapshot.data!;
                  return Padding(
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: screenSize.height * 0.03),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundImage: user.photo != null
                                          ? NetworkImage(user.photo as String)
                                          : const NetworkImage(
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaaNaTC8W_ygKLZxLFWpHOerfIYQiVlsuyrw&s'),
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height * 0.03),
                                  Text("Name",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: screenSize.height * 0.01),
                                  TextField(
                                    cursorColor:
                                        Theme.of(context).colorScheme.primary,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        filled: true,
                                        hintText: user.name,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                  ),
                                  SizedBox(height: screenSize.height * 0.03),
                                  Text(
                                    "Date of birth",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: screenSize.height * 0.01),
                                  TextField(
                                    cursorColor:
                                        Theme.of(context).colorScheme.primary,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        filled: true,
                                        hintText: user.dob,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        suffixIcon: Icon(
                                          Icons.calendar_month,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        )),
                                    readOnly: true,
                                    onTap: () async {
                                      final DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now());
                                      if (pickedDate != null) {
                                        signupcontroller.dob.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                      }
                                    },
                                  ),
                                  SizedBox(height: screenSize.height * 0.03),
                                  Text("Email",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: screenSize.height * 0.01),
                                  TextField(
                                    cursorColor:
                                        Theme.of(context).colorScheme.primary,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        hintText: user.email,
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                  ),
                                  SizedBox(height: screenSize.height * 0.03),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.06),
                        ],
                      ),
                    ),
                  );
                }
              },
            )));
  }
}
