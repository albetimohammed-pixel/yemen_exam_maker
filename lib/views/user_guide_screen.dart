import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/guide_item.dart';

class UserGuideScreen extends StatelessWidget {
  UserGuideScreen({Key? key}) : super(key: key);

  final List<GuideItem> guideSteps = [
    GuideItem(
      title: '1. إعداد الترويسة والشعارات',
      description: 'قم بتفعيل خيار الترويسة من الشريط السفلي، واختر الشعارات الرسمية (شعار الدولة، الوزارة، أو المدرسة) وقم بضبط إظهار/إخفاء البسملة بنقرة واحدة.',
      icon: Icons.view_headline,
    ),
    GuideItem(
      title: '2. تخصيص أشرطة الأسئلة',
      description: 'من تبويب "السؤال"، استخدم أشرطة السحب لضبط عرض الشريط، حجم الخط (sp)، حشوات الإطار، وإظهار أو إخفاء مربع درجات السؤال والعمود الجانبي.',
      icon: Icons.edit_note,
    ),
    GuideItem(
      title: '3. تصميم الحدود والإطارات',
      description: 'انتقل لتبويب "الإطار" للتحكم بسماكة الحدود الخارجية والداخلية، المسافة الفاصلة، وانحناء الزوايا، مع إمكانية التبديل بين خلفيات وأطر جاهزة.',
      icon: Icons.crop_square,
    ),
    GuideItem(
      title: '4. ضبط استوديو العلامة المائية',
      description: 'من تبويب "العلامة المائية"، اضبط نسبة الشفافية وزاوية الدوران والحجم لضمان حفظ حقوق الورقة دون التأثير على وضوح نصوص الأسئلة.',
      icon: Icons.branding_watermark,
    ),
    GuideItem(
      title: '5. توليد ورقة الإجابة والطباعة',
      description: 'أنشئ ورقة إجابة نموذجية تلقائية لأسئلة (صح/خطأ) و(الاختيار من متعدد) بلغة اختيارك (عربي/إنجليزي)، ثم اضغط زر "طباعة" للتصدير المباشر كـ PDF.',
      icon: Icons.print,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل استخدام المحرر المدرسي'),
        backgroundColor: AppColors.darkPurple,
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.backgroundDark,
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: guideSteps.length,
          itemBuilder: (context, index) {
            final item = guideSteps[index];
            return Card(
              color: AppColors.cardDark,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.white12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.accentGreen.withOpacity(0.2),
                      child: Icon(item.icon, color: AppColors.accentGreen),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

