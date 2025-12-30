import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class BreastCancerScreen extends StatefulWidget {
  const BreastCancerScreen({super.key});

  @override
  State<BreastCancerScreen> createState() => _BreastCancerScreenState();
}

class _BreastCancerScreenState extends State<BreastCancerScreen> {
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
      title: 'BREAST CANCER',
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
                _buildPage2(),
                _buildPage1(),
                _buildPage3(),
              ],
            ),
          ),
          // Dot Indicators
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildDotIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            const Text(
              'BREAST CANCER SYMPTOMS',
              style: TextStyle(
                color: Color(0xFFE91E63),
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
            // Breast Cancer Images Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              children: [
                Image.asset('assets/images/first_b.png', fit: BoxFit.contain),
                Image.asset('assets/images/fourth_b.png', fit: BoxFit.contain),
                Image.asset('assets/images/third_b.png', fit: BoxFit.contain),
                Image.asset('assets/images/fourth_b.png', fit: BoxFit.contain),
                Image.asset('assets/images/fifth_b.png', fit: BoxFit.contain),
                Image.asset('assets/images/sixth_b.png', fit: BoxFit.contain),
                Image.asset('assets/images/seventh_b.png', fit: BoxFit.contain),
                Image.asset('assets/images/eighth_b.png', fit: BoxFit.contain),
              ],
            ),
            const SizedBox(height: 20), // Add bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            _buildContentSection(
              'BREAST CANCER',
              'Breast cancer is the most common cancer among women in India. The incidence has rapidly increased in the past years. Early detection is the key to the treatment of breast cancer. There are steps you can take to detect breast cancer early when it is most treatable.',
            ),
            const SizedBox(height: 20),
            _buildContentSection(
              'Screening',
              'The incidence of breast cancer increases after the age of 40 but it can also be seen in younger women. Women who have a family history of breast cancer and other cancer and have other high-risk factors are more likely to develop breast cancer.The success of treatment depends upon the stage in which the diseases are diagnosed. Earlier the diseases are diagnosed the better is the treatment response. As most cases of breast cancer have no symptoms, it is important that all women undergo regular screening.',
            ),
            const SizedBox(height: 20),
            _buildContentSection(
              'The common symptoms of breast cancers are:',
              '•Painless lump or hardness in the breast or armpit\n'
              '•Skin changes, retraction of the nipple\n'
              '•Nipple discharge.\n'
              '\nIt is important to educate to watch for these signs regularly and consult a doctor immediately if any such symptoms appear.'
            ),
            const SizedBox(height: 20),
            _buildContentSection(
                'Breast cancer screening method includes:',
                '•Breast Self-Examination\n'
                '•Clinical breast examination\n'
                '•Mammography\n'
                '•Sono Mammography\n'
                '•Thermo mammography'
            ),
            const SizedBox(height: 50), // Add bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            _buildContentSection(
              'Breast Cancer Prevention',
              '•Breast cancer Prevention starts with healthy habits such as limiting alcohol and staying active. Understand how to reduce your breast cancer risk.'
            ),
            const SizedBox(height: 30),
            // Prevention Images Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              children: [
                Image.asset(
                  'assets/images/breast_feed.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading breast_feed.png: $error');
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
                Image.asset(
                  'assets/images/Be_physical.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading Be_physical.png: $error');
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
                Image.asset(
                  'assets/images/eat_healthy.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading eat_healthy.png: $error');
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
                Image.asset(
                  'assets/images/limit.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading limit.png: $error');
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
                Image.asset(
                  'assets/images/maintain.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading maintain.png: $error');
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
                Image.asset(
                  'assets/images/smoking.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading smoking.png: $error');
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
              ],
            ),
            const SizedBox(height: 50), // Add bottom padding
          ],
        ),
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
            : Colors.grey.withValues(alpha: 0.5),
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
