import 'package:flutter/material.dart';
import 'package:canprotect_flutter/screens/health_profile_screen.dart';
import 'package:canprotect_flutter/screens/cervical_cancer_screen.dart';
import 'package:canprotect_flutter/screens/breast_cancer_screen.dart';
import 'package:canprotect_flutter/screens/bse_language_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/base_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _homeCircle(String assetPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'HOME',
      showTitleInTopBar: false,
      content: SingleChildScrollView(
        child: Column(
          children: [
            // HOME Title
            const Align(
              alignment: Alignment(0, -1.0),
              child: Text(
                'HOME',
                style: TextStyle(
                  color: Color(0xFFE91E63),
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 2),

            // Circles grid
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
                children: [
                  _homeCircle('assets/images/first_home.png', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BSELanguageScreen()),
                    );
                  }),
                  _homeCircle('assets/images/second_home.png', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HealthProfileScreen()),
                    );
                  }),
                  _homeCircle('assets/images/second_home_new.png',
                      onTap: () => Navigator.pushNamed(context, '/health_history')),
                  _homeCircle('assets/images/fourth_home.png',
                      onTap: () => Navigator.pushNamed(context, '/reminders')),
                  _homeCircle('assets/images/fifth_home.png', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BreastCancerScreen()),
                    );
                  }),
                  _homeCircle('assets/images/sixth_home.png', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CervicalCancerScreen()),
                    );
                  }),
                  _homeCircle('assets/images/seventh_home.png',
                      onTap: () =>
                          _launchExternalUrl('http://canprotectfoundation.com/upcoming-programs/')),
                  _homeCircle('assets/images/eightth_home.png',
                      onTap: () =>
                          _launchExternalUrl('http://canprotectfoundation.com/programs-update/')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
