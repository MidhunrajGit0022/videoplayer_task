import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:videoplayer/features/auth/auth_controller.dart/signup_controller.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();
  final signupcontroller = Get.put(SignUpController());
  final pinController = TextEditingController();
  final SmsAutoFill _autoFill = SmsAutoFill();
  StreamSubscription? _subscription;

  String? email;
  String? otpCode;

  RxInt secondsRemaining = 60.obs;
  Timer? _timer;
  final otp = ''.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      email = Get.arguments["email"];
    } else {}
    generateOtp();
    startCountdown();
    listenForOtp();
  }

  void startCountdown() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        secondsRemaining--;
        if (secondsRemaining < 1) {
          otp.value = '';
          timer.cancel();
          resendOtp();
        }
      },
    );
  }

  void generateOtp() {
    const int otpLength = 4;
    const String chars = '0123456789';
    var random = Random();
    for (int i = 0; i < otpLength; i++) {
      otp.value += chars[random.nextInt(chars.length)];
    }
    _sendEmail();
  }

  void _sendEmail() async {
    String username = 'midhuncode0022@gmail.com';
    String password = 'xeoo ntzn cthr wdxh';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(email)
      ..subject = 'OTP verification for Videoplayer'
      ..html =
          '<p>VideoPlayer Use the following OTP to complete the registration process. OTP is valid for 1 minute. Do not share this code with others.</p><br><br><h1 style="text-align: center; color: red;"><span style="font-weight: bold;">${otp.value}</span></h1><br><br>';
    try {
      await send(message, smtpServer);
      print("OTP sent successfully! ");
    } catch (e) {
      print("error otp");
    }
  }

  void verifyOtp(String pin) {
    if (pinController.text == otp.value) {
      Get.put(SignUpController()).register();
      print("OTP verified successfully!");
      Get.snackbar('Success', 'OTP verified successfully!');
    } else {
      clearFields();
      Get.snackbar("Invalid OTP", "Invalid OTP", backgroundColor: Colors.red);
    }
  }

  void clearFields() {
    pinController.clear();
  }

  void resendOtp() {
    generateOtp();
    startCountdown();
  }

  void listenForOtp() async {
    _subscription = SmsAutoFill().code.listen((code) {
      otpCode = code;
      verifyOtp(otpCode!);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    SmsAutoFill().unregisterListener();
    super.onClose();
  }

  @override
  void dispose() {
    signupcontroller.dispose();
    super.dispose();
  }
}
