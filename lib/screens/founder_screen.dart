import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class FounderScreen extends StatelessWidget {
  const FounderScreen({super.key});

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
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFFE91E63)),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'FOUNDER',
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
                            'About the Founder',
                            style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Dr. Sumita Prabhakar',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'President and Founder, Can Protect Foundation',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            'Dr. Sumita Prabhakar’s journey in women’s health began like that of many doctors, inside hospitals and clinics, caring for patients one at a time. Over 27 years as an obstetrician and gynecologist, she has seen joy, relief, and recovery, but she has also seen something deeply troubling. Too many women were reaching hospitals only when their breast cancer or cervical cancer had already advanced. Not because they ignored their health, but because they had never been told what to look for, had never learned about the Breast Self Exam, and had never had access to screening.\n\nThis realization changed the direction of her work.\n\nTrained at Banaras Hindu University and later honored with FRCOG from London, Dr. Prabhakar serves as Head of the Gynecology Department at CMI Hospital in Dehradun. She also leads IVF India Care and Laserwell, a laser and cosmetic gynecology clinic. While these roles keep her busy, her heart has always been with women who stand outside the reach of regular healthcare.\n\nIn 2015, she founded the Can Protect Foundation with a simple belief, that awareness and early detection should not be a privilege. They should reach every woman, even in the most remote village.\n\nSince then, her work has taken her far beyond hospital corridors. She and her team travel to hilly regions, rural communities, and underserved areas where organizing a health camp is never easy. Long journeys, limited facilities, and social hesitation are part of the reality. Many women come with fear, and many come with no symptoms at all, unaware that early screening can save their lives.\n\nThrough these camps, more than 37,000 women have received free screening for breast and cervical health in the past several years. Hundreds of pre-cancerous and early stage conditions have been detected in time, allowing women to seek treatment early and return to their families with hope.\n\nDr. Prabhakar strongly believes that lasting change comes from awareness within the community. That is why she started Asha Ki Kiran, a program that trains ASHA and ANM workers in Breast Cancer Awareness, Cervical Cancer Awareness, and Breast Self Exam, so they can guide women in their own villages. Over 1,200 frontline health workers have been trained so far. Through Meri Maa Swasth Maa, she works with school children, helping them understand their mother’s health and encouraging conversations about prevention at home.\n\nShe also helped develop CanApp, a regional language Breast Cancer Awareness app, so that important health information is available in a simple and familiar form.\n\nOver the years, her work in women’s health and cancer prevention has been acknowledged by various medical and social institutions. She has received honors such as the IMA Doctor Achievement Award, Uma Shakti Samman from the Governor of Uttarakhand, Health Icon Award by Times of India, Medical Excellence Awards from leading media groups, and recognition from the Chief Minister of Uttarakhand. These recognitions reflect the growing importance of preventive women’s healthcare and the collective efforts of the teams working on the ground.\n\nDespite the recognition, her focus remains unchanged, to ensure that fewer women lose their lives simply because they did not know, or did not have access to timely screening.\n\nDr. Sumita Prabhakar’s journey shows how one doctor’s concern grew into a movement of awareness, early detection, and hope for thousands of women and families.',
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
