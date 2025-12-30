import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';

class AvadhiScreen extends StatefulWidget {
  const AvadhiScreen({super.key});

  @override
  State<AvadhiScreen> createState() => _AvadhiScreenState();
}

class _AvadhiScreenState extends State<AvadhiScreen> {
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
              ],
            ),
          ),
          const SizedBox(height: 20),
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
          children: const [
            Text(
              'स्वयं स्तन परीक्षण – अवधि मा\n\nस्तन कैंसर के इलाज बड़ै से बहुत ज़रूरी हो की ई का पहचान जल्दी जल्दी से हो जाव। अगर रखा लोग समय-समय पर आपनी जाँच खुद करल, तब आपन स्तन मा होन वाला कबी बदलाव कु आसानी से समझ जाव। एक परीक्षण महीना आवे के एक सप्ताह भीतर कर लेवो चाहिए। जिन महिलाओं के महीना ना आवे, उ एक महीने मा भी कोनों एक दिन खुद का जाँच कर सकदा।\n\nई जाँच मा कुछ खर्चा नी और ना कोनों समय लागे। एक बड़े आसानी से रखा लोग घर मा कर लेवो और आपन स्तन के जान समझ लेवो। एक बेर अगर तोह लोगन के कोनों परिवर्तन लागे, त फट से डॉक्टर के दिखाव।\n\nखुद क परीक्षण बड़ै कोनों मैमोग्राफी का विकल्प ना हो, बल्कि ई कैंसर जागरूकता बड़ै बहुत ज़रूरी बा। सब महिलान के ई हर महीने करे के चाही।\n\nस्पर्श:\n\nआपन तीन उँगलियन का इस्तेमाल करके आपन स्तन पर 25 पैसा जितना गोल-गोल बनाते हुए दबाव डालो। हल्का दबाव लगावो होते हुए बगल से शुरू कर के पूरा स्तन पर करलो। ईही तरह दूसरा स्तन पर भी करलो। ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20),
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
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_one.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'परीक्षण परिधि:\n\nआपन तीन उँगली के स्तन पर ऊपर से नीचे ले जावे के चाही। गाल के नीचे का हड्डी से आपन बगल तक। यही तरह दूसरा स्तन पर करा।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_two.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
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
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_three.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'शीशा के सामने\n\nशीशा के सामने खड़े हो के आपन दोनों हाथ नीचे के ओरि रखो और देखो कि स्तन का आकार, निप्पल का रंग, बनावट और निप्पल का बिंदु का दिशा में कऊनो परिवर्तन ता नहीं बा।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_four.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'एही चीज़ की आपन दोनों हाथ सर के ऊपर रख के देखो।',
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
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_five.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'एकरे बाद आपन दोनों हाथ आपन कंधा पर रख के आपन छाती के मांसपेशी के कसो। अब देखो कि स्तन पर कऊनो खड्डा, झुरी, लाली, पपड़ी या गांठ या रंग में परिवर्तन ता ना बा।\n\nकोनो तरह का बहाव का जाँच करे खातिर, अंगूठा और तर्जनी उँगली के बीच निप्पल के निचोड़ के देखो, कोनो बहाव ता नाही होत बा।\n\nसुबह उठ के देखो, कपड़े या निप्पल पर कोनो बहाव ता नाही होत हो। निप्पल से बहाव सामान्य नाही बा।\n\nनहात समय\n\nनहात समय साबुन और पानी लगा रहे, ता एकर जाँच आसानी से हो सकत बा। नहात समय आपन दहिने हाथ के सर के ऊपर रखो और “स्पर्श” तकनीक से जाँच करा।',
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
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_six.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'पीठ की बल\n\nपीठ के बल लेट के जाँच करने में आसानी होत हो। आपन दाहिना कंधा के नीचे एक तकिया रखो, बायाँ हाथ से दाएँ बगल से शुरू करो और 25 पैसा के आकार जेतना गोल-गोल बनाते हुए देखो। हल्का, मध्यम और तेज दबाव से देखो और दुसर स्तन में भी यही करो।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_seven.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
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
            Center(
              child: Image.asset(
                'assets/images/garhwali_img_eight.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.pink, size: 60);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'यदि रखा के स्तन में कउनो दिक्कत लगे, जैसे कि गांठ, दर्द, रंग में परिवर्तन, बहाव, निप्पल में कउनो दिक्कत दिखे त तुरंत आपन डॉक्टर के दिखावा। बहुत सारे गांठ या बदलाव कैंसर ना होत बा, लेकिन एक डॉक्टर के दिखावा के ज़रूरी बा, उनके मूल्यांकन कर के देखे के ज़रूरी बा।',
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
          children: const [
            Text(
              'यदि रखा के स्तन में कउनो दिक्कत लगे, जैसे कि गांठ, दर्द, रंग में परिवर्तन, बहाव, निप्पल में कउनो दिक्कत दिखे ता तुरंत आपन डॉक्टर के दिखावा। बहुत सा गांठ, या बदलाव से कैंसर ना होता बा, लेकिन एक डॉक्टर के दिखावे के ज़रूरी बा, उनके मूल्यांकन कर के देखे के ज़रूरी बा।\n\nस्तन का कउनो बीमारी हो, खुद के जाँच परीक्षण कर के, रखा लोगन पता कर लेब। एके आपन दिनचर्या में शामिल करा और बाकी महिला लोगन से भी बतावा।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20),
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
}
