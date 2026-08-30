import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../controllers/editor_controller.dart';

class TemplatePickerSheet extends StatelessWidget {
  final EditorController controller;

  const TemplatePickerSheet({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'اختر قالب الألوان السريع:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTemplateCard(
                title: 'افتراضي',
                primary: Colors.blue,
                accent: Colors.amber,
                onTap: () {
                  controller.setQuestionPrimaryColor(Colors.blue);
                  Navigator.pop(context);
                },
              ),
              _buildTemplateCard(
                title: 'أزرق ملكي',
                primary: const Color(0xFF1A237E),
                accent: Colors.cyan,
                onTap: () {
                  controller.setQuestionPrimaryColor(const Color(0xFF1A237E));
                  Navigator.pop(context);
                },
              ),
              _buildTemplateCard(
                title: 'ذهبي فاخر',
                primary: const Color(0xFFD4AF37),
                accent: Colors.black,
                onTap: () {
                  controller.setQuestionPrimaryColor(const Color(0xFFD4AF37));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard({
    required String title,
    required Color primary,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primary, width: 2),
        ),
        child: Column(
          children: [
            CircleAvatar(backgroundColor: primary, radius: 14),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
