import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/health_profile_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String healthProfile = '/health_profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      profile: (context) => const ProfileScreen(),
      healthProfile: (context) => const HealthProfileScreen(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case healthProfile:
        return MaterialPageRoute(builder: (_) => const HealthProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
