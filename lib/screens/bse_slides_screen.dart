import 'package:flutter/material.dart';

class BSESlidesScreen extends StatefulWidget {
  final int languageIndex;
  final String languageName;

  const BSESlidesScreen({
    super.key,
    required this.languageIndex,
    required this.languageName,
  });

  @override
  State<BSESlidesScreen> createState() => _BSESlidesScreenState();
}

class _BSESlidesScreenState extends State<BSESlidesScreen> {
  final List<Map<String, dynamic>> _bseContent = [];
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadContent();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadContent() {
    // Sample BSE content based on language
    if (widget.languageIndex == 0) {
      // English content
      _bseContent.addAll([
        {
          'title': 'Breast Self Examination (BSE)',
          'subtitle': 'Do It for Yourself',
          'content': 'Breast self-examination aims to familiarize a woman about her breast. Early detection is important to achieve the best treatment outcome in breast cancer. If you regularly examine your breast you can feel and detect any changes at the earliest.',
          'image': null,
        },
        {
          'title': '1. Position (Standing)',
          'content': 'Stand undressed to the waist in front of a mirror and look at your breast in three positions:\n\n1. Arm relaxed at sides.\n2. Arms raised on the head.\n3. Press your hands firmly on your waist.\n\nLook at your breasts for any changes in size and shape. Colour, and texture of nipples, skin and the direction of your nipples point.',
          'image': true,
        },
        {
          'title': '1.1. Position (Lying Down)',
          'content': 'Lie on your back, so that breast tissue can spread more evenly across the chest wall. Place your right hand behind your head. Use the finger pad of three middle fingers of your left hand.',
          'image': true,
        },
        {
          'title': '2. Perimeter (where to feel)',
          'content': 'The area to be examined should include all the tissue of the breast and the arm-pit. The tissue of the breast is divided into four segments plus the area around the nipple.',
          'image': true,
        },
        {
          'title': '3. Palpation with Finger (How to Feel)',
          'content': 'Using three middle fingers of the opposite hand, feel both breasts. Start feeling from the armpit. Feel breast by moving fingers in a 25 paisa coin size circular motion.',
          'image': true,
        },
        {
          'title': '4. Pressure (How Deep to Feel)',
          'content': 'Use three pressure levels for each palpation, from light to deep, to analyze the full thickness of your breast tissue. The pressure is crucial because the breast is not flat.',
          'image': true,
        },
      ]);
    } else if (widget.languageIndex == 1) {
      // Hindi content
      _bseContent.addAll([
        {
          'title': 'स्वयं स्तन परिक्षण',
          'subtitle': 'सीखिए एवं सिखाइए',
          'content': 'स्तन स्व-परीक्षण का उद्देश्य एक महिला को उसके स्तन के बारे में अवगत कराना है। स्तन कैंसर के बेहतर इलाज के लिए इसकी प्रारंभिक चरण महत्वपूर्ण है।',
          'image': null,
        },
        // Add more Hindi content...
      ]);
    }
    // Add other languages...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.languageName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink.shade600,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bseContent.length,
              onPageChanged: (i) {
                setState(() {
                  _pageIndex = i;
                });
              },
              itemBuilder: (context, index) {
                final content = _bseContent[index];
                return Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (content['title'] != null)
                          Text(
                            content['title'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade700,
                            ),
                          ),
                        if (content['subtitle'] != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            content['subtitle'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink.shade600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        if (content['image'] == true)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.pink.shade50,
                              child: Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.pink.shade200,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          content['content'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_pageIndex + 1} / ${_bseContent.length}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                IconButton(
                  onPressed: _pageIndex <= 0
                      ? null
                      : () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          ),
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton(
                  onPressed: _pageIndex >= _bseContent.length - 1
                      ? null
                      : () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          ),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
