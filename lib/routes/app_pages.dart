import 'package:get/get.dart';
import 'package:online_notes/presentation/screens/auth/waiting_for_verification_screen.dart';
import 'package:online_notes/presentation/screens/home/home_screen.dart';
import 'package:online_notes/presentation/screens/login_screen.dart';
import 'package:online_notes/presentation/screens/signup_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import 'app_bindings.dart';


class AppPages {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const verification = '/verification';
  static const home = '/home';


  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen(), binding: AppBindings()),
    GetPage(name: login, page: () => const LoginScreen(), binding: AppBindings()),
    GetPage(name: register, page: () => SignupScreen(), binding: AppBindings()),
    GetPage(name: verification, page: () => const WaitingForVerificationScreen(), binding: AppBindings()),
    GetPage(name: home, page: () => const HomeScreen(), binding: AppBindings()),
  ];
}

