import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/bse_language_screen.dart';
import 'screens/breast_cancer_screen.dart';
import 'screens/cervical_cancer_screen.dart';
import 'screens/health_history_screen.dart';
import 'screens/health_profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reminder_options_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/webview_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CanProtectApp());
}

class CanProtectApp extends StatelessWidget {
  const CanProtectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CanProtect',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/bse': (context) => BSELanguageScreen(),
        '/health_profile': (context) {
          print('Health Profile route accessed');
          return const HealthProfileScreen();
        },
        '/health_history': (context) => const HealthHistoryScreen(),
        '/reminders': (context) => const ReminderOptionsScreen(),
        '/breast_cancer': (context) => const BreastCancerScreen(),
        '/cervical_cancer': (context) => const CervicalCancerScreen(),
        '/webview': (context) => const WebViewScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
