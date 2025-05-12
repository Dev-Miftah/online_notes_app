import 'package:go_router/go_router.dart';
import 'package:online_notes/presentation/screens/add_note/add_notes_screen.dart';
import 'package:online_notes/presentation/screens/auth/waiting_for_verification_screen.dart';
import 'package:online_notes/presentation/screens/home/home_screen.dart';
import 'package:online_notes/presentation/screens/auth/login_screen.dart';
import 'package:online_notes/presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import 'app_bindings.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        AuthBinding().dependencies();
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        AuthBinding().dependencies();
        return LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        AuthBinding().dependencies();
        return SignupScreen();
      },
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) {
        AuthBinding().dependencies();
        final extra = state.extra as Map<String, dynamic>?;
        final fullName = extra?['fullName'] ?? '';
        return WaitingForVerificationScreen(fullName: fullName);
      },
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) {
        NoteBinding().dependencies();
        return HomeScreen();
      },
    ),
    GoRoute(
      path: '/add-note',
      builder: (context, state) {
        NoteBinding().dependencies();
        return AddNoteScreen();
      },
    ),
  ],
);
