// lib/utils/router.dart
import 'package:go_router/go_router.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/intake_feelings_screen.dart';
import '../screens/intake_addiction_screen.dart';
import '../screens/intake_support_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/dashboard_screen.dart';

// Mirrors the Stack.Navigator in trustai-app/App.js
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',                    builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/login',               builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register',            builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/intake/feelings',     builder: (_, __) => const IntakeFeelingsScreen()),
    GoRoute(path: '/intake/addiction',    builder: (_, __) => const IntakeAddictionScreen()),
    GoRoute(path: '/intake/support',      builder: (_, __) => const IntakeSupportScreen()),
    GoRoute(path: '/intake/privacy',      builder: (_, __) => const PrivacyScreen()),
    GoRoute(path: '/dashboard',           builder: (_, __) => const DashboardScreen()),
  ],
);
