import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_background.dart';
import '../screens/profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../services/logout_service.dart';
import '../core/constants/app_constants.dart';

class BaseScreen extends StatefulWidget {
  final String? title;
  final Widget content;
  final bool showTitleInTopBar;
  final bool showBottomButtons;
  final bool showSideIcons;
  final bool showSocialIcons;

  const BaseScreen({
    super.key,
    this.title,
    required this.content,
    this.showTitleInTopBar = false,
    this.showBottomButtons = true,
    this.showSideIcons = true,
    this.showSocialIcons = true,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoggedIn();
    });
  }

  Future<void> _ensureLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);
    if (!mounted) return;
    if (token == null || token.isEmpty) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }

  Future<void> _logout(BuildContext dialogContext) async {
    final navigator = Navigator.of(context);
    Navigator.of(dialogContext).pop();

    Map<String, dynamic>? response;
    try {
      response = await LogoutService.logout();
    } catch (_) {
      response = null;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);

    if (!mounted) return;

    if (response != null) {
      final statusCode = response['statusCode'];
      final isOk = statusCode == 200 || statusCode == 201;
      if (!isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed on server. You have been logged out locally.'),
            backgroundColor: Colors.pink,
          ),
        );
      }
    }

    navigator.pushNamedAndRemoveUntil('/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        topTintOpacity: 0.25,
        bottomTintOpacity: 0.06,
        child: Stack(
          children: [
            // Top Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: Image.asset('assets/images/profile_icon.png', width: 35, height: 35),
                    ),
                    if (widget.showTitleInTopBar && widget.title != null)
                      Text(
                        widget.title!,
                        style: const TextStyle(
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: 1.2,
                        ),
                      )
                    else
                      const SizedBox(width: 35), // Spacer when no title
                    GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          builder: (dialogContext) {
                            Widget buildMenuButton(String label, VoidCallback onPressed) {
                              return SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: onPressed,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: Color(0xFFE91E63),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }

                            void showNotReady(String label) {
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(label),
                                  backgroundColor: Colors.pink,
                                ),
                              );
                            }

                            return Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    buildMenuButton(
                                      'How to use this app?',
                                      () => showNotReady('How to use this app?'),
                                    ),
                                    const SizedBox(height: 8),
                                    buildMenuButton('Our Story', () => showNotReady('Our Story')),
                                    const SizedBox(height: 8),
                                    buildMenuButton('Founder', () => showNotReady('Founder')),
                                    const SizedBox(height: 8),
                                    buildMenuButton('Contact us', () => showNotReady('Contact us')),
                                    const SizedBox(height: 8),
                                    buildMenuButton(
                                      'Change Password',
                                      () {
                                        Navigator.of(dialogContext).pop();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    buildMenuButton('Logout', () => _logout(dialogContext)),
                                    const SizedBox(height: 8),
                                    buildMenuButton(
                                      'Close',
                                      () => Navigator.of(dialogContext).pop(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset('assets/images/sub_menu_icon.png', width: 35, height: 35),
                    ),
                  ],
                ),
              ),
            ),
            
            // Border Image with Content
            Align(
              alignment: const Alignment(0, -0.07),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double targetWidth = constraints.maxWidth * 0.8;
                  final double targetHeight = targetWidth * 2;
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: targetWidth,
                      height: targetHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/bg_white_border.png',
                            fit: BoxFit.fill,
                          ),
                          // Content Widget (customizable for each screen)
                          widget.content,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Section with Donate and Volunteer Buttons
            if (widget.showBottomButtons)
              Align(
                alignment: const Alignment(0, 0.8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/donate_button.png', height: 36, fit: BoxFit.contain),
                      const SizedBox(width: 16),
                      Image.asset('assets/images/volunteer_button.png', height: 36, fit: BoxFit.contain),
                    ],
                  ),
                ),
              ),
            
            // Side Icons
            if (widget.showSideIcons) ...[
              Align(
                alignment: const Alignment(-0.91, 0.87),
                child: Image.asset('assets/images/web_icon.png', height: 42, fit: BoxFit.contain),
              ),
              Align(
                alignment: const Alignment(0.91, 0.87),
                child: Image.asset('assets/images/phone_icon.png', height: 42, fit: BoxFit.contain),
              ),
            ],
            
            // Social Icons
            if (widget.showSocialIcons)
              Align(
                alignment: const Alignment(0, 0.93),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/facebook_icon.png', height: 32, fit: BoxFit.contain),
                    const SizedBox(width: 24),
                    Image.asset('assets/images/instagram_icon.png', height: 32, fit: BoxFit.contain),
                    const SizedBox(width: 24),
                    Image.asset('assets/images/twitter_icon.png', height: 32, fit: BoxFit.contain),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
