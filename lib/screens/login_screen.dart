import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../services/login_service.dart';
import '../widgets/app_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await LoginService.login(email: email, password: password);
      final statusCode = response['statusCode'];
      final isOk = statusCode == 200 || statusCode == 201;
      if (!isOk) {
        final message = _extractErrorMessage(response) ?? 'Login failed.';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        return;
      }

      final token = _extractToken(response) ?? 'local_session';
      final userId = _extractUserId(response);
      final userProfile = _extractUserProfile(response);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userTokenKey, token);
      if (userId != null && userId.trim().isNotEmpty) {
        await prefs.setString(AppConstants.userIdKey, userId.trim());
      }
      if (userProfile != null) {
        await prefs.setString(AppConstants.userProfileKey, userProfile);
      }

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String? _extractErrorMessage(Map<String, dynamic> response) {
    final message = response['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();

    final errors = response['errors'];
    if (errors is Map) {
      for (final v in errors.values) {
        if (v is List && v.isNotEmpty) {
          final first = v.first;
          if (first is String && first.trim().isNotEmpty) return first.trim();
        }
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
    }
    return null;
  }

  String? _extractUserId(Map<String, dynamic> response) {
    String? pick(dynamic v) {
      if (v == null) return null;
      if (v is String && v.trim().isNotEmpty) return v.trim();
      if (v is num) return v.toString();
      return null;
    }

    final direct = pick(response['user_id']) ?? pick(response['userId']) ?? pick(response['id']);
    if (direct != null) return direct;

    final user = response['user'];
    if (user is Map) {
      final fromUser = pick(user['id']) ?? pick(user['user_id']) ?? pick(user['userId']);
      if (fromUser != null) return fromUser;
    }

    final data = response['data'];
    if (data is Map) {
      final fromData = pick(data['user_id']) ?? pick(data['userId']) ?? pick(data['id']);
      if (fromData != null) return fromData;

      final dataUser = data['user'];
      if (dataUser is Map) {
        return pick(dataUser['id']) ?? pick(dataUser['user_id']) ?? pick(dataUser['userId']);
      }
    }
    return null;
  }

  String? _extractUserProfile(Map<String, dynamic> response) {
    dynamic user = response['user'];
    if (user == null) {
      final data = response['data'];
      if (data is Map) {
        user = data['user'];
      }
    }

    if (user is Map) {
      try {
        return jsonEncode(user);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  String? _extractToken(Map<String, dynamic> response) {
    String? pick(dynamic v) {
      if (v is String && v.trim().isNotEmpty) return v.trim();
      return null;
    }

    final direct = pick(response['token']) ?? pick(response['access_token']);
    if (direct != null) return direct;

    final data = response['data'];
    if (data is Map) {
      return pick(data['token']) ?? pick(data['access_token']);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/logo_circle.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Can Protect Foundation',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Please login to continue',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  hint: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  hint: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 10)),
                    ],
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF3D7F), Color(0xFFE91E63)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: _loading ? null : _login,
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/register', (_) => false);
                  },
                  child: const Text(
                    'New user? Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFE91E63)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
