import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class CervicalCancerScreen extends StatefulWidget {
  const CervicalCancerScreen({super.key});

  @override
  State<CervicalCancerScreen> createState() => _CervicalCancerScreenState();
}

class _CervicalCancerScreenState extends State<CervicalCancerScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'CERVICAL CANCER',
      showTitleInTopBar: false,
      content: Column(
        children: [
          // PageView for content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPage1(),
                _buildPage2(),
                _buildPage3(),
                _buildPage4(),
              ],
            ),
          ),
          // Dot Indicators
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: _buildDotIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        children: [
          // Cervical Cancer Image
          Image.asset(
            'assets/images/cervical_cancer_img.png',
            width: 200,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          _buildContentSection(
            'What is cervical cancer?',
            'Cervical cancer is a type of cancer that occurs in the cells of the cervix — the lower part of the uterus that connects to the vagina. Various strains of the human papilloma virus (HPV).',
          ),
          const SizedBox(height: 20),
          _buildContentSection(
            'Human Papilloma Virus (HPV)',
            'Human papillomavirus virus (HPV) is a very common infection. Four out of five (80%) people will be infected with genital HPV at some time during their lives. Most people can fight this infection and never develop any problem.',
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(height: 80),
          _buildContentSection(
            'Signs and Symptoms',
            '• The early stages of cervical cancer may be completely free of symptoms\n'
            '• Vaginal bleeding\n'
            '• Moderate pain during sexual intercourse\n'
            '• Vaginal discharge',
          ),
          const SizedBox(height: 20),
          _buildContentSection(
            'Cervical Cancer Risk Factors',
            '• Starting sex at a young age\n'
            '• Smoking\n'
            '• Weak immune system\n'
            '• Long use of birth control pills\n'
            '• Having many sexual partners\n'
            '• Multiple pregnancies and abortions\n'
            '• Sexually transmitted diseases (STDs)',
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(height: 120), // Space to align with page 1 image
          _buildContentSection(
            'How can I protect myself from cervical cancer?',
            '• Practice safe sex\n'
                '• Use a condom or barrier method\n'
                '• Limit your number of sex partners\n'
                '• Don’t smoke\n'
                '• Get regular Pap smear tests\n'
                '• HPV vaccination',
          ),

        ],
      ),
    );
  }

  Widget _buildPage4() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(height: 80), // Space to align with page 1 image
          _buildContentSection(
            'Cervical Cancer Prevention – Screening',
            '• Pap smear is a simple, painless, and inexpensive test\n'
                '• Pap smear should be done regularly by women three years after first sexual contact until the age of 70\n'
                '• After 3 normal Pap smear results, one Pap smear can be done every 3 years\n'
                '• The best time to do a Pap smear is after periods\n'
                '• Sometimes, along with your Pap smear, your doctor may recommend HPV virus testing\n'
                '• If your Pap smear is abnormal, a colposcopy and biopsy are done\n'
                '• Regular Pap smears have drastically reduced the incidence of cervical cancer in many developed countries\n'
                '• Sometimes VIA (visual inspection of cervix with acetic acid) is done for mass screening of cervical cancer\n'
                '• Acetic acid can identify pre-cancerous changes\n'
                '• You can contact Can Protect Foundation for regular scheduling of a Pap smear',
          ),

        ],
      ),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        const SizedBox(width: 8),
        _buildDot(1),
        const SizedBox(width: 8),
        _buildDot(2),
        const SizedBox(width: 8),
        _buildDot(3),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? const Color(0xFFE91E63)
            : Colors.grey.withOpacity(0.5),
      ),
    );
  }

  Widget _buildContentSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE91E63),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
