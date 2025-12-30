import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';

class EnglishScreen extends StatefulWidget {
  const EnglishScreen({super.key});

  @override
  State<EnglishScreen> createState() => _EnglishScreenState();
}

class _EnglishScreenState extends State<EnglishScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'LEARN',
      showTitleInTopBar: true,
      content: Column(
        children: [
          const SizedBox(height: 40),
          // PageView for swiping screens
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
                _buildPage5(),
                _buildPage6(),
                _buildPage7(),
                _buildPage8(),
                _buildPage9(),
              ],
            ),
          ),
          const SizedBox(height: 20), // Bottom margin
          // Dot indication for more content
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(0),
              const SizedBox(width: 8),
              _buildDot(1),
              const SizedBox(width: 8),
              _buildDot(2),
              const SizedBox(width: 8),
              _buildDot(3),
              const SizedBox(width: 8),
              _buildDot(4),
              const SizedBox(width: 8),
              _buildDot(5),
              const SizedBox(width: 8),
              _buildDot(6),
              const SizedBox(width: 8),
              _buildDot(7),
              const SizedBox(width: 8),
              _buildDot(8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Breast Self Examination (BSE)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Do It for Yourself',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Breast self-examination aims to familiarize a woman about her breast. Early detection is important to achieve the best treatment outcome in breast cancer. If you regularly examine your breast you can feel and detect any changes at the earliest.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'CanApp will help you know exactly how to do Breast self-examination but it is best to discuss any queries and limitation of BSE with your doctor.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Some key tips to remember:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('Do Breast self-examination once a month after the period when the breast is soft.'),
            _buildTip('If you no longer have a period you can do it on any fixed day of the month.'),
            _buildTip('If you\'re breastfeeding, express milk to empty the breast before BSE.'),
            _buildTip('Both breasts must be examined.'),
            _buildTip('If you notice any changes or abnormal symptoms discuss with your doctor immediately.'),
            _buildTip('Remember, most changes in the breast are NOT cancer, and treatable.'),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Add the BSE image
            Center(
              child: Image.asset(
                'assets/images/first_bse.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Position (Standing)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Stand undressed to the waist in front of a mirror and look at your breast in three positions:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('Arm relaxed at sides.'),
            _buildTip('Arms raised on the head.'),
            _buildTip('Press your hands firmly on your waist.'),
            const SizedBox(height: 8),
            const Text(
              'Look at your breasts for any changes in size and shape. Colour, and texture of the nipples, skin and the direction of your nipples point (notice if there is any retraction of the nipple).',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Add the BSE lying down image
            Center(
              child: Image.asset(
                'assets/images/second_bse.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '1.1. Position (Lying Down)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lie on your back, so that the breast tissue can spread more evenly across the chest wall. In this position you will be able to feel the whole breast easily. Place your right hand behind your head. It may be helpful to place a pillow or a rounded towel under your right shoulder (from the back to the breast).',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To examine the right breast, use the finger pad (front part of three fingers) of the 3 middle fingers of your left hand. Do the same for the left breast.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Look for any stain of nipple discharge, brown, red or yellow on your clothes. Nipple discharge is not normal.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage4() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Add the BSE perimeter image
            Center(
              child: Image.asset(
                'assets/images/third_bse.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '2. Perimeter (where to feel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The area to be examined should include all the tissue of the breast and the arm-pit (as shown in the photo).',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The tissue of the breast is divided into four segments (parts) plus the area around the nipple.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage5() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Add the BSE palpation image
            Center(
              child: Image.asset(
                'assets/images/fourth_bse.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '3. Palpation with Finger (How to Feel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Using three middle fingers of the opposite hand feel both breasts, one after another.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('Start feeling from the armpit.'),
            _buildTip('Feel breast by moving fingers in a 25 paisa coin size circular motion.'),
            _buildTip('If you wish powder or lotion can be applied on your fingers to feel the breasts.'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage6() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Add the BSE pressure image
            Center(
              child: Image.asset(
                'assets/images/fifth_bse.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '4. Pressure (How Deep to Feel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use three pressure levels for each palpation, from light to deep, to analyze the full thickness of your breast tissue. The pressure is crucial because the breast is not flat. You have to feel all the way through the tissue to your ribs.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage7() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Add the BSE pattern image
            Center(
              child: Image.asset(
                'assets/images/sixth_bse.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '5. Pattern of Search',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Think of your breast as a clock.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('Start examining your breast from your armpit and move all around the breast in a small circular motion.'),
            _buildTip('Keep going all around the circle till you reach the armpit again.'),
            _buildTip('Keep your fingers flat and in constant contact with the breast. When the circle is complete, move one inch towards the nipple and complete this next circle around the clock.'),
            _buildTip('Continue with this pattern until you feel the whole breast.'),
            _buildTip('You must feel the tissue beneath the nipples and the armpits.'),
            _buildTip('Finally, gently squeeze your nipples.'),
            const SizedBox(height: 8),
            const Text(
              'If you have any discharge, consult with your doctor.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.3)),
              ),
              child: const Text(
                'IF YOU FEEL ANY HARDNESS, LUMP, PAIN, COLOR OR TEXTURE CHANGE IN SKIN CONSULT YOUR DOCTOR FOR FURTHER EVALUATION. YOU CAN MARK ANY AREA OF LUMP, COLOR CHANGE AND PAIN IN UPDATE HEALTH PROFILE SECTION OF THIS APP. THIS WILL HELP YOU IN MONITORING THE CHANGES IN YOUR BREAST.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFE91E63),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage8() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              '6. Practice Feedback',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your doctor or nurse will show you how to do BSE. Then ask them to watch you do the exam and see that you\'re doing it right. Ask them to describe and let you feel the different types of tissue in your breast so that you know what\'s normal for you.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.3)),
              ),
              child: const Text(
                'If you feel anything new in your breasts, get medical help right away.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFE91E63),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage9() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              '7. Regular Breast Screening',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 12),
            _buildTip('Start monthly breast self-examination soon after you start getting period.'),
            _buildTip('Once a year see your doctor for a clinical breast examination.'),
            _buildTip('If you are 35 or above have mammography or sonomammography as advised by doctor.'),
            _buildTip('You may require earlier and more intensive screening if you have a family history of cancer or other high-risk factors.'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Note: Generally breast tissue feels nodular but if you feel hardness like pea/grape, it may be a lump.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Any discharge white/green/yellow/brown/red is abnormal.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index 
            ? const Color(0xFFE91E63) 
            : const Color(0xFFE91E63).withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFE91E63),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
