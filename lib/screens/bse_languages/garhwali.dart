import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';

class GarhwaliScreen extends StatefulWidget {
  const GarhwaliScreen({super.key});

  @override
  State<GarhwaliScreen> createState() => _GarhwaliScreenState();
}

class _GarhwaliScreenState extends State<GarhwaliScreen> {
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
              'गढ़बड़ी माँ जानव कि स्तन की\nजाँच आपही कनके करें जाँच\n\nस्तन कैंसर कु अच्छु इलाज करन का रास्ता ये की पहचान शुरू माँ ही कन जरूरी चा। अगर आप टेम-टेम अपना स्तनों की जाँच करल, त आप की बाद पर स्तनों माँ होन वाले बदलाव कु भी पता कर सकदा। हर महीना माँ ये बार मासिक होया का एक हफ्ता बाद स्तन कु परीक्षण आपही करन चह्दा। अर जदि मासिक नै आन्द, तु ये माँ एक बार कभी भी स्तनों कु परीक्षण करन चह्दा।\n\nस्तनों की आपही जाँच करन माँ टैम भी थो कम लागद अर कबी खर्च भी नै होन्द। ये थी आप अपना घर माँ आसानी से कर सकदा अर ये से आपन ये भी पता चलन्दु कि, आपन स्तन माँ सब सामान्य चा या कुछ असामान्य चा। अगर आप ये दौरान अपना स्तनों माँ कुछ परिवर्तन देखन्द, त डॉक्टर माँ जाके जाँच करन चह्दा। ',
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
              'ये थे अपना बगल यानी कखयाई दिशा बटी शुरू कन अर यन के पूरा स्तन की जाँच करण। बिल्कुल यनी के दूसरा स्तन की भी जाँच करण।',
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
              'ऐना का सामने खड़ा हुण:\n\nदुई हाथु से अपना शरीर दाहिने नीचे के तरफ रखण। अर जांच करण की स्तन कु आकार अर निप्पल कु रंग अथवा, त्वचा अर निप्पल का बिंदु दिशा में कबी परिवर्तन त नीच।',
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
              'ई का बाद दुई हाथु से मुड़ा का ऐंव (ऊपर) रखण। अर अजी जांच करण की स्तन कु आकार या निप्पल कु रंग अर त्वचा अर निप्पल का बिंदु दिशा में कबी परिवर्तन त नीच।',
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
              'ई का बाद अब दुई हाथ्य थे अपना कन्धों यानी कमर बटी थोड़ु नीचे रखण अर छाती पे करणा। अब देखण कि स्तन माँ कबी खड्डा, झुर्रियाँ, लालीमा, पपड़ी, गांठ या कबी आकृति या त्वचा का रंग माँ कुछ बदलु त नी।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'फिर डिस्चार्ज यानी की पानी जन कुछ त निकलु, ई जाँच करणु का वास्ता अंगूठा अर वी की बगल वाली तर्जनी उंगली बीच निप्पल थे निचोड़ी की देखो।\n\nखासे ऊँ ध्यान राखो कि कपड़ों पर निप्पल बटी कबी भूरो, लाल या पीले रंगु का कबी डिस्चार्ज त नि हुण जाये। निप्पल डिस्चार्ज वास्ता नी मानु जाँच, यानि की ए सामान्य बात नीच।\n\nनारीण बात\n\nनारीण बात जब आप बच्चा गीली अर साबुन लगी होई, तब ई टैम पर आसानी से आपकी जाँच कर सकदा।',
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
              'ई का वास्ता अपणा दैणा हाथ थे अपणा मुड़ा माँ धरिके, अर स्पर्श तकनिक कु उपयोग करिके स्तनों की जाँच करणु चह्दा।\n\nपीठ टेक्कि की लेटी की\n\nपीठ थे टेक्कि की सीधा माँ लेटी जाव, इन करण से स्तन समतल हो जाव, अर जाँच करण आसान हो जाव।',
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
            const SizedBox(height: 12),
            const Text(
              'ई का बाद दैणा कंधा का नीचे एक तकिया थे धरा। बांगां हाथ बटी दैणा बाल बटी शुरू करा। अर 25 पैसा जति छोटा गोल-गोल घुमावा अर यनी के पूरी जाँच की शृंखला बनावता जाव, जनि कि नीचे चित्र माँ दिखावू।',
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
              'ईका लाइ हल्का अर गहरा या ज्यादा दबाव कु उपयोग करा। दबाव मा परीक्षण परिधि जू की माथि (ऊपर), बगल, बनी कु जाँच दोहरावा। ई की का जाँच पूरा स्तन थे निप्पल अर बगल तक करि अर दूसरा स्तन पर भी ये ही जाँच थे दोहरावा।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'अगर आप थे अपना स्तनों माँ कबी असामान्य बात दिखेन्द, जनि कि गांठ, दर्द, रंग माँ बदलाव, डिस्चार्ज, निप्पल माँ कबी भी प्रकार का परिवर्तन दिखेन्द या महसूस होन्द, त आप तुरंत अपना डॉक्टर थे दिखाव अर उ से सलाह लयाव।\n\nएक बात ई भी ध्यान रखो कि ज्यादातर स्तन गांठ या बदलाव कैंसर नि होन्द, पर आपनी जाँच करण मा आप थे जू ई बदलाव दिखेन्द उ ई डॉक्टर थे दिखाव जरूरी चा जाँच।\n\nहर महीना आपनी स्तन जाँच करिके सभी महिला स्तन माँ होन वाली कबी भी बीमारी कु पता जल्दी लगी सकदी। ई ले आपनी स्तन जाँच थे आप अपनी आदत बनाव।',
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
