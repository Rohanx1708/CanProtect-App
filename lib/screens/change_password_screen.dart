import 'package:flutter/material.dart';

import '../services/change_password_service.dart';
import '../widgets/app_background.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _currentPasswordServerError;

  @override
  void initState() {
    super.initState();
    _currentController.addListener(() {
      if (_currentPasswordServerError != null) {
        setState(() {
          _currentPasswordServerError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
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

  Future<void> _submit() async {
    if (_loading) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final currentPassword = _currentController.text;
    final newPassword = _newController.text;
    final confirmation = _confirmController.text;

    setState(() {
      _loading = true;
    });

    try {
      final response = await ChangePasswordService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmation,
      );

      final statusCode = response['statusCode'];
      final isOk = statusCode == 200 || statusCode == 201;

      if (!mounted) return;

      if (!isOk) {
        final msg = _extractErrorMessage(response) ?? 'Failed to change password.';
        final errors = response['errors'];
        final hasCurrentPasswordError = (errors is Map) &&
            (errors.containsKey('current_password') ||
                errors.containsKey('currentPassword') ||
                errors.containsKey('current')); 

        final isCurrentPasswordIncorrect = hasCurrentPasswordError ||
            (msg.toLowerCase().contains('current') && msg.toLowerCase().contains('password'));

        if (isCurrentPasswordIncorrect) {
          setState(() {
            _currentPasswordServerError = msg;
          });
          _formKey.currentState?.validate();
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
        return;
      }

      _currentController.clear();
      _newController.clear();
      _confirmController.clear();

      setState(() {
        _currentPasswordServerError = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully.')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        topTintOpacity: 0.25,
        bottomTintOpacity: 0.06,
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFE91E63)),
                    ),
                    const SizedBox(width: 28, height: 28),
                    const SizedBox(width: 28, height: 28),
                  ],
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double w = constraints.maxWidth * 0.80;
                    final double h = w * 2;
                    return SizedBox(
                      width: w,
                      height: h,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/images/bg_white_border.png', fit: BoxFit.fill),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  const Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'CHANGE PASSWORD',
                                      style: TextStyle(
                                        color: Color(0xFFE91E63),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 34),
                                  const Text(
                                    'Current Password',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  _field(
                                    controller: _currentController,
                                    obscureText: _obscureCurrent,
                                    validator: (value) {
                                      final v = value ?? '';
                                      if (v.isEmpty) return 'Current password is required.';
                                      if (_currentPasswordServerError != null) return _currentPasswordServerError;
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureCurrent = !_obscureCurrent;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                                        color: const Color(0xFFE91E63),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'New Password',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  _field(
                                    controller: _newController,
                                    obscureText: _obscureNew,
                                    validator: (value) {
                                      final v = value ?? '';
                                      if (v.isEmpty) return 'New password is required.';
                                      if (v.length < 6) return 'New password must be at least 6 characters.';
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureNew = !_obscureNew;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureNew ? Icons.visibility_off : Icons.visibility,
                                        color: const Color(0xFFE91E63),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Confirm New Password',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  _field(
                                    controller: _confirmController,
                                    obscureText: _obscureConfirm,
                                    validator: (value) {
                                      final v = value ?? '';
                                      if (v.isEmpty) return 'Confirm password is required.';
                                      if (v != _newController.text) return 'Passwords do not match.';
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirm = !_obscureConfirm;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                        color: const Color(0xFFE91E63),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Center(
                                    child: Container(
                                      width: 170,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFFF3D7F), Color(0xFFE91E63)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 10)),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(22),
                                          onTap: _loading ? null : _submit,
                                          child: Center(
                                            child: _loading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                                  )
                                                : const Text(
                                                    'CHANGE',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
