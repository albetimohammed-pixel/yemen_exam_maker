import 'package:flutter/material.dart';
import '../models/question_template_config.dart';

class QuestionBarWidget extends StatelessWidget {
  final String questionNumber;
  final String questionTitle;
  final String gradeText;
  final QuestionTemplateConfig config;

  const QuestionBarWidget({
    Key? key,
    required this.questionNumber,
    required this.questionTitle,
    required this.gradeText,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double titleFontSize = config.fontSizeSp * config.fontScale;
    final double gradeFontSize = config.gradeFontSizeSp * config.fontScale;

    return Container(
      width: config.barWidth,
      padding: EdgeInsets.all(config.padding),
      decoration: BoxDecoration(
        color: config.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(config.cornerRadius),
        border: Border.all(
          color: config.primaryColor,
          width: config.borderWidth,
        ),
      ),
      child: Row(
        children: [
          if (config.showSidebar)
            Container(
              width: 4,
              height: 24,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: config.accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Expanded(
            child: Text(
              '$questionNumber: $questionTitle',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          if (config.showGradeBox)
            Container(
              width: config.gradeBoxWidth,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              decoration: BoxDecoration(
                color: config.primaryColor,
                borderRadius: BorderRadius.circular(config.cornerRadius / 2),
              ),
              child: Center(
                child: Text(
                  gradeText,
                  style: TextStyle(
                    fontSize: gradeFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
