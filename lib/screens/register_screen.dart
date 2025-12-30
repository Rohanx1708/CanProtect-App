import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../services/register_service.dart';
import '../widgets/app_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _maritalController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  String? _selectedMaritalStatus;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const List<String> _maritalStatusOptions = <String>[
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _maritalController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final marital = (_selectedMaritalStatus ?? _maritalController.text).trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    final city = _cityController.text.trim();
    final password = _passwordController.text;
    final passwordConfirmation = _confirmPasswordController.text;
    final parsedAge = int.tryParse(age);

    if (parsedAge == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final response = await RegisterService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        age: parsedAge,
        maritalStatus: marital,
        mobile: mobile,
        city: city,
      );

      final statusCode = response['statusCode'];
      final isOk = statusCode == 200 || statusCode == 201;
      if (!isOk) {
        final message = _extractErrorMessage(response) ?? 'Registration failed.';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final profile = <String, dynamic>{
        'name': name,
        'age': age,
        'marital_status': marital,
        'mobile': mobile,
        'email': email,
        'city': city,
      };

      await prefs.setString(AppConstants.userProfileKey, jsonEncode(profile));
      await prefs.remove(AppConstants.userTokenKey);

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String? _extractErrorMessage(Map<String, dynamic> response) {
    String? pickFromErrors(dynamic errors) {
      if (errors is! Map) return null;
      for (final v in errors.values) {
        if (v is List && v.isNotEmpty) {
          final first = v.first;
          if (first is String && first.trim().isNotEmpty) return first.trim();
        }
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      return null;
    }

    final topLevelErrors = pickFromErrors(response['errors']);
    if (topLevelErrors != null) return topLevelErrors;

    final data = response['data'];
    final nestedErrors = data is Map ? pickFromErrors(data['errors']) : null;
    if (nestedErrors != null) return nestedErrors;

    final message = response['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();

    final raw = response['raw'];
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
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
                    'an initiative by Dr. Sumita Prabhakar',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    hint: 'Your Name',
                    controller: _nameController,
                    validator: (value) {
                      final v = (value ?? '').trim();
                      if (v.isEmpty) return 'Name is required.';
                      return null;
                    },
                  ),
                  _buildTextField(
                    hint: 'Age',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final v = (value ?? '').trim();
                      if (v.isEmpty) return 'Age is required.';
                      final parsed = int.tryParse(v);
                      if (parsed == null) return 'Age must be a number.';
                      if (parsed <= 0) return 'Age must be greater than 0.';
                      if (parsed > 120) return 'Age must be 120 or less.';
                      return null;
                    },
                  ),
                  _buildMaritalStatusDropdown(),
                  _buildTextField(
                    hint: 'Mobile Number',
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      final raw = (value ?? '').trim();
                      if (raw.isEmpty) return 'Mobile number is required.';

                      final digitsOnly = raw.replaceAll(RegExp(r'\D'), '');
                      if (digitsOnly.length != raw.length) {
                        return 'Mobile number must contain digits only.';
                      }
                      if (digitsOnly.length != 10) {
                        return 'Mobile number must be 10 digits.';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    hint: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final v = (value ?? '').trim();
                      if (v.isEmpty) return 'Email is required.';
                      if (!v.contains('@')) return 'Enter a valid email.';
                      return null;
                    },
                  ),
                  _buildTextField(
                    hint: 'City',
                    controller: _cityController,
                    validator: (value) {
                      final v = (value ?? '').trim();
                      if (v.isEmpty) return 'City is required.';
                      return null;
                    },
                  ),
                  _buildTextField(
                    hint: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      final v = value ?? '';
                      if (v.isEmpty) return 'Password is required.';
                      if (v.length < 6) return 'Password must be at least 6 characters.';
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFE91E63),
                      ),
                    ),
                  ),
                  _buildTextField(
                    hint: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      final v = value ?? '';
                      if (v.isEmpty) return 'Confirm password is required.';
                      if (v != _passwordController.text) return 'Passwords do not match.';
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFE91E63),
                      ),
                    ),
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
                        onTap: _loading ? null : _register,
                        child: Center(
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'REGISTER',
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
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                    },
                    child: const Text(
                      'Already registered? Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
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
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFE91E63)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMaritalStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedMaritalStatus,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
        hint: const Text('Marital Status', style: TextStyle(color: Color(0xFFE91E63))),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          final v = (value ?? '').trim();
          if (v.isEmpty) return 'Marital status is required.';
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: _maritalStatusOptions
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.black87)),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedMaritalStatus = value;
            _maritalController.text = value ?? '';
          });
        },
      ),
    );
  }
}
