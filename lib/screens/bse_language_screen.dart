import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import 'bse_languages/english.dart';
import 'bse_languages/hindi.dart';
import 'bse_languages/garhwali.dart';
import 'bse_languages/avadhi.dart';

class BSELanguageScreen extends StatelessWidget {
  const BSELanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'BSE LANGUAGE',
      showTitleInTopBar: true,
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.2,
              children: [
                _buildLanguageCard(context, 'English', 'assets/images/english.png'),
                _buildLanguageCard(context, 'Hindi', 'assets/images/hindi.png'),
                _buildLanguageCard(context, 'Garhwali', 'assets/images/garhwali.png'),
                _buildLanguageCard(context, 'Avadhi', 'assets/images/avadhi.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, String language, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (language == 'English') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EnglishScreen(),
            ),
          );
        } else if (language == 'Hindi') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HindiScreen(),
            ),
          );
        } else if (language == 'Garhwali') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GarhwaliScreen(),
            ),
          );
        } else if (language == 'Avadhi') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AvadhiScreen(),
            ),
          );
        } else {
          // Handle other language selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$language language selected'),
            ),
          );
        }
      },
      child: Image.asset(
        imagePath,
        height: 80,
        width: 80,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.language, color: Colors.pink, size: 40);
        },
      ),
    );
  }
}