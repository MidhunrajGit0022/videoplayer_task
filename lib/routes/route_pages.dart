import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:videoplayer/features/auth/auth_views/login_page.dart';
import 'package:videoplayer/features/auth/auth_views/otp_page.dart';
import 'package:videoplayer/features/auth/auth_views/signup_page.dart';
import 'package:videoplayer/views/dashboard.dart';
import 'package:videoplayer/views/profile.dart';

var pages = [
  GetPage(name: "/login", page: () => const Login_page()),
  GetPage(name: "/signup", page: () => const Signup_page()),
  GetPage(name: "/dashboard", page: () => const Dashboard()),
  GetPage(name: "/profile", page: () => const Profile_page()),
  GetPage(name: "/otppage", page: () => const Otp()),
];
