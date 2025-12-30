import 'package:flutter/material.dart';

import '../services/change_password_service.dart';
import '../widgets/app_background.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;

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

    final currentPassword = _currentController.text;
    final newPassword = _newController.text;
    final confirmation = _confirmController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    if (newPassword != confirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirmation do not match.')),
      );
      return;
    }

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.pink),
        );
        return;
      }

      _currentController.clear();
      _newController.clear();
      _confirmController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully.')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password: $e'), backgroundColor: Colors.pink),
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
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset('assets/images/profile_icon.png', width: 28, height: 28),
                    ),
                    const Text(
                      'CHANGE PASSWORD',
                      style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(width: 28, height: 28),
                  ],
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double w = constraints.maxWidth * 0.80;
                    final double h = w * 1.35;
                    return SizedBox(
                      width: w,
                      height: h,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/images/bg_white_border.png', fit: BoxFit.fill),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Current Password',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  _field(controller: _currentController, obscureText: true),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'New Password',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  _field(controller: _newController, obscureText: true),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Confirm New Password',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  _field(controller: _confirmController, obscureText: true),
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

  static Widget _field({required TextEditingController controller, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
