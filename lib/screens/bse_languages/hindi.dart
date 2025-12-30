import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';

class HindiScreen extends StatefulWidget {
  const HindiScreen({Key? key}) : super(key: key);

  @override
  _HindiScreenState createState() => _HindiScreenState();
}

class _HindiScreenState extends State<HindiScreen> {
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
      title: 'सीखें',
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
                _buildPage8(),
                _buildPage9(),
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
              'स्तन स्व-परीक्षण ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'सीखिए एवं सिखाइए',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'स्तन स्व-परीक्षण का उद्देश्य महिला को अपने स्तनों के बारे में परिचित कराना है। स्तन कैंसर में बेहतर उपचार परिणाम के लिए जल्दी पहचान महत्वपूर्ण है। यदि आप नियमित रूप से अपने स्तनों की जांच करती हैं, तो आप किसी भी बदलाव को सबसे पहले महसूस कर सकती हैं।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'CanApp आपको बताएगा कि स्तन स्व-परीक्षण कैसे करना है, लेकिन स्तन स्वयं-परीक्षण की सीमाओं और किसी भी प्रश्न के लिए अपने डॉक्टर से चर्चा करना सबसे अच्छा है।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'याद रखने योग्य महत्वपूर्ण बातें:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('महीने में एक बार पीरियड्स के बाद (जब स्तन नरम हों) स्तन स्वयं-परीक्षण करें।'),
            _buildTip('यदि पीरियड्स नहीं आते, तो महीने के किसी निश्चित दिन स्तन स्वयं-परीक्षण करें।'),
            _buildTip('यदि आप स्तनपान कर रही हैं, तो स्तन स्वयं-परीक्षण से पहले दूध निकालकर स्तन खाली कर लें।'),
            _buildTip('दोनों स्तनों की जांच करनी चाहिए।'),
            _buildTip('यदि कोई बदलाव या असामान्य लक्षण दिखें, तो तुरंत डॉक्टर से संपर्क करें।'),
            _buildTip('याद रखें, स्तन में अधिकांश बदलाव कैंसर नहीं होते और उपचार योग्य होते हैं।'),
            const SizedBox(height: 20),
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
              '1. स्थिति (खड़े होकर)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'कमर तक कपड़े उतारकर शीशे के सामने खड़े हों और तीन स्थितियों में अपने स्तनों को देखें:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('हाथ दोनों तरफ ढीले रखें।'),
            _buildTip('हाथ सिर के ऊपर उठाएं।'),
            _buildTip('हाथ कमर पर रखकर मजबूती से दबाएं।'),
            const SizedBox(height: 8),
            const Text(
              'स्तनों के आकार और आकृति में बदलाव, रंग, निप्पल/त्वचा की बनावट और निप्पल की दिशा देखें (यदि निप्पल अंदर की ओर खिंच रहा हो तो नोट करें)।',
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
              '1.1. स्थिति (लेटकर)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'पीठ के बल लेटें, ताकि स्तन ऊतक छाती की दीवार पर समान रूप से फैल सके। इस स्थिति में पूरा स्तन आसानी से महसूस किया जा सकता है। दाहिना हाथ सिर के पीछे रखें। दाहिने कंधे के नीचे (पीठ से स्तन तक) तकिया या गोल तौलिया रखना मददगार हो सकता है।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'दाहिने स्तन की जांच के लिए बाएं हाथ की मध्य की 3 उंगलियों के पल्प (अगले हिस्से) का उपयोग करें। बाएं स्तन के लिए भी यही करें।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'कपड़ों पर निप्पल से किसी भी प्रकार के स्राव (भूरा/लाल/पीला) के दाग देखें। निप्पल से स्राव सामान्य नहीं है।',
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
              '2. परिधि (कहाँ महसूस करना है)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'जांच का क्षेत्र स्तन के सभी ऊतकों और बगल (फोटो में दिखाए अनुसार) को शामिल करना चाहिए।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'स्तन ऊतक को निप्पल के आसपास के क्षेत्र सहित चार भागों (सेगमेंट) में बाँटा जा सकता है।',
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
              '3. उंगलियों से स्पर्श (कैसे महसूस करें)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'विपरीत हाथ की मध्य की तीन उंगलियों से एक-एक करके दोनों स्तनों को महसूस करें।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('बगल से महसूस करना शुरू करें।'),
            _buildTip('उंगलियों को 25 पैसे के सिक्के जितनी गोलाकार गति में घुमाते हुए महसूस करें।'),
            _buildTip('यदि चाहें, तो उंगलियों पर पाउडर/लोशन लगाकर भी स्तन महसूस कर सकती हैं।'),
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
              '4. दबाव (कितना गहरा महसूस करें)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'हर स्पर्श में तीन स्तर के दबाव का उपयोग करें: हल्का, मध्यम और गहरा। दबाव महत्वपूर्ण है क्योंकि स्तन सपाट नहीं होते। आपको ऊतक के पूरे हिस्से को पसलियों तक महसूस करना चाहिए।',
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
              '5. खोज का पैटर्न',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'अपने स्तन को घड़ी (clock) की तरह सोचें।',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            _buildTip('बगल से शुरू करें और छोटे गोलाकार गति में पूरे स्तन के चारों ओर बढ़ें।'),
            _buildTip('घड़ी के चारों ओर घूमते हुए फिर से बगल तक आएं।'),
            _buildTip('उंगलियाँ सपाट रखें और लगातार संपर्क में रखें। एक चक्र पूरा होने पर निप्पल की ओर लगभग 1 इंच अंदर जाकर अगला चक्र पूरा करें।'),
            _buildTip('इसी पैटर्न में तब तक जारी रखें जब तक पूरे स्तन को महसूस न कर लें।'),
            _buildTip('निप्पल के नीचे और बगल के ऊतक भी महसूस करें।'),
            _buildTip('अंत में, निप्पल को धीरे से दबाएँ।'),
            const SizedBox(height: 8),
            const Text(
              'यदि किसी प्रकार का स्राव हो, तो डॉक्टर से सलाह लें।',
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
                'यदि आपको कोई कठोरता, गांठ, दर्द, त्वचा के रंग/बनावट में बदलाव महसूस हो, तो आगे की जांच के लिए डॉक्टर से संपर्क करें। आप ऐप के “Update Health Profile” सेक्शन में गांठ, रंग में बदलाव और दर्द वाले क्षेत्र को मार्क कर सकती हैं। इससे स्तन में होने वाले बदलावों की निगरानी में मदद मिलेगी।',
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
              '6. अभ्यास फीडबैक',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'आपका डॉक्टर या नर्स आपको स्तन स्वयं-परीक्षण करना सिखाएंगे। इसके बाद उनसे कहें कि वे आपको स्तन स्वयं-परीक्षण करते हुए देखें और सुनिश्चित करें कि आप इसे सही तरीके से कर रही हैं। उनसे अपने स्तन के अलग-अलग प्रकार के ऊतकों का वर्णन करने और आपको महसूस कराने के लिए कहें, ताकि आपको पता हो कि आपके लिए क्या सामान्य है।',
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
                'यदि आपको स्तनों में कुछ भी नया महसूस हो, तो तुरंत चिकित्सकीय सहायता लें।',
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
              '7. नियमित स्तन स्क्रीनिंग',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 12),
            _buildTip('पीरियड्स शुरू होने के बाद से ही मासिक स्तन स्वयं-परीक्षण शुरू करें।'),
            _buildTip('साल में एक बार डॉक्टर से क्लिनिकल ब्रेस्ट एग्ज़ामिनेशन कराएँ।'),
            _buildTip('यदि आपकी उम्र 35 वर्ष या अधिक है, तो डॉक्टर की सलाह अनुसार मैमोग्राफी/सोनोमैमोग्राफी कराएँ।'),
            _buildTip('यदि परिवार में कैंसर का इतिहास या अन्य उच्च जोखिम कारक हों, तो जल्दी और अधिक स्क्रीनिंग की आवश्यकता हो सकती है।'),
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
                    'नोट: आमतौर पर स्तन ऊतक में गाँठ-सी (nodular) भावना हो सकती है, लेकिन यदि मटर/अंगूर जैसी कठोरता महसूस हो, तो वह गांठ हो सकती है।',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'किसी भी प्रकार का स्राव (सफेद/हरा/पीला/भूरा/लाल) असामान्य है।',
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