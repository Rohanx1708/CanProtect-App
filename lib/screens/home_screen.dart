import 'package:flutter/material.dart';
import 'package:_flutter/screens/health_profile_screen.dart';
import 'package:_flutter/screens/cervical_cancer_screen.dart';
import 'package:_flutter/screens/breast_cancer_screen.dart';
import 'package:_flutter/screens/bse_language_screen.dart';
import 'package:_flutter/screens/bse_findings_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/base_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _homeCircle(
    String assetPath, {
    VoidCallback? onTap,
    BoxFit fit = BoxFit.contain,
    double scale = 1.0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child: Transform.scale(
            scale: scale,
            child: Image.asset(
              assetPath,
              fit: fit,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'HOME',
      showTopBar: true,
      showBrandInTopBar: true,
      showTitleInTopBar: false,
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Circles grid
            Transform.translate(
              offset: const Offset(0, -12),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.04,
                  children: [
                    _homeCircle('assets/images/first_home.png', onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BSELanguageScreen()),
                      );
                    }),
                    _homeCircle('assets/images/second_home.png', onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HealthProfileScreen()),
                      );
                    }),
                    _homeCircle(
                      'assets/images/second_home_new.png',
                      onTap: () => Navigator.pushNamed(context, '/health_history'),
                    ),
                    _homeCircle(
                      'assets/images/bsefindings.png',
                      fit: BoxFit.contain,
                      scale: 1.03,
                      onTap: () {
                        final userId = (ModalRoute.of(context)?.settings.arguments ?? '').toString().trim();
                        if (userId.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Unable to open BSE Findings: missing user id.')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BseFindingsScreen(patientId: userId)),
                        );
                      },
                    ),
                    _homeCircle(
                      'assets/images/fourth_home.png',
                      onTap: () => Navigator.pushNamed(context, '/reminders'),
                    ),
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
                    _homeCircle(
                      'assets/images/seventh_home.png',
                      onTap: () => _launchExternalUrl(
                        'http://foundation.com/upcoming-programs/',
                      ),
                    ),
                    _homeCircle(
                      'assets/images/eightth_home.png',
                      onTap: () => _launchExternalUrl(
                        'http://foundation.com/programs-update/',
                      ),
                    ),
                    _homeCircle(
                      'assets/images/videos.png',
                      fit: BoxFit.contain,
                      scale: 1.01,
                      onTap: () => _launchExternalUrl(
                        'https://www.youtube.com/@canprotectfoundation7303',
                      ),
                    ),
                  ],
                ),
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
