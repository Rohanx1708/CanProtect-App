import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class OurStoryScreen extends StatelessWidget {
  const OurStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        topTintOpacity: 0.25,
        bottomTintOpacity: 0.06,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFE91E63)),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'OUR STORY',
                      style: TextStyle(
                        color: Color(0xFFE91E63),
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 18),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Our Story',
                            style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            'Big change often begins with a simple but powerful decision, to not look away.\n\nIn 2015, Dr. Sumita Prabhakar saw a painful truth unfolding across India. Women were losing their lives to breast cancer and cervical cancer, not only because of the disease, but because of lack of Breast Cancer Awareness, Cervical Cancer Awareness, and access to early screening. In villages, small towns, and remote hilly regions, women had never even heard of Breast Self Exam or preventive cancer checkups. Fear, social hesitation, and limited healthcare facilities were silently costing lives.\n\nShe decided that this had to change.\n\nThat decision gave birth to the Can Protect Foundation, a grassroots movement committed to bringing cancer awareness and screening directly to women who need it the most. What began as a small effort with limited resources has grown into a mission that now reaches thousands of women across Uttarakhand and several other states in India.\n\nOur work is not easy. We travel to remote mountain villages, difficult terrains, and underserved rural areas where even basic healthcare is hard to access. Organizing camps often means long journeys, logistical challenges, and convincing families who have never been exposed to the idea of preventive screening. Many women come to us with hesitation, fear, or no symptoms at all, believing they are fine. That is where awareness becomes life saving.\n\nThrough our Breast Cancer Awareness and Cervical Cancer Awareness programs, we educate women about early signs, risk factors, and most importantly, the importance of regular screening even when there are no symptoms. We actively teach Breast Self Exam so that women can take charge of their own health at home.\n\nTo make early detection possible in low resource settings, we use advanced and portable technologies such as Thermo Mammography, Mobile Colposcopy, iBreastExam, and Breastlight. These tools allow us to provide modern, non invasive screening services right at the doorstep of villages and small communities.\n\nSo far, more than 37,000 women have received free screening for breast and cervical diseases through our health camps across Uttarakhand, Haryana, Punjab, Uttar Pradesh, and Himachal Pradesh. Every month, our dedicated team of doctors, health workers, and volunteers continues to organize cancer prevention and women’s health camps in both cities and remote areas.\n\nOur commitment goes beyond cancer. We also work in other critical areas of women’s health such as anemia prevention, adolescent health education, menopausal health awareness, and overall preventive healthcare. Because when a woman is healthy, an entire family becomes stronger.\n\nWe believe awareness must spread from within communities. Through our Asha Ki Kiran campaign, we train ASHA and ANM workers in women’s health, Breast Cancer Awareness, Cervical Cancer Awareness, and screening guidance so they can educate others in their own villages. Through Meri Maa Swasth Maa, we empower students with knowledge about cancer prevention and encourage them to care for their mothers’ health. These initiatives are creating a ripple effect of awareness across generations.\n\nToday, Can Protect Foundation is a registered society under the Societies Registration Act XXI, 1860, and is also registered under 12A and 80G, allowing donors to support this life saving work with eligible tax benefits. What started as a small initiative has grown into a leading cancer prevention organization, but our mission remains deeply human and urgent.\n\nFor us, this work is not about numbers. It is about mothers, daughters, sisters, and grandmothers who deserve a healthy life. It is about reaching the woman in the last village who has never had a screening. It is about replacing fear with knowledge, and late detection with timely care.\n\nWe believe Breast Cancer Awareness saves lives. Cervical Cancer Awareness protects families. Breast Self Exam empowers women. Early detection gives hope.\n\nThis is our journey. And we will keep walking, village by village, woman by woman, until awareness and screening reach everyone.',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
