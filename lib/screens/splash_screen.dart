import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../widgets/app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      _goNext();
    });
  }

  Future<void> _goNext() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        alignment: const Alignment(0, -0.25),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 0),
                // Title block slightly above center
                const Spacer(flex: 2),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Can Protect ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const TextSpan(
                            text: 'APP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Opacity(
                      opacity: 0.35,
                      child: SizedBox(
                        width: 260,
                        child: Divider(height: 1, thickness: 0.6, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'SAVING WOMEN FROM CANCER',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Opacity(
                      opacity: 0.35,
                      child: SizedBox(
                        width: 260,
                        child: Divider(height: 1, thickness: 0.6, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: 0.85,
                      child: Text(
                        'POWERED BY:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
                          BoxShadow(color: Colors.black12, blurRadius: 24, spreadRadius: 2, offset: Offset(0, 10)),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/logo_circle.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                // Bottom foundation text near bottom
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Can Protect ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const TextSpan(
                            text: 'Foundation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'an initiative by Dr. Sumita Prabhakar',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
