import 'package:flutter/material.dart';

class QuestionTemplateConfig {
  double barWidth;
  double gradeBoxWidth;
  double padding;
  double cornerRadius;
  double borderWidth;
  double fontSizeSp;
  double gradeFontSizeSp;
  double fontScale;
  bool showSidebar;
  bool showGradeBox;
  Color primaryColor;
  Color accentColor;

  QuestionTemplateConfig({
    this.barWidth = 300.0,
    this.gradeBoxWidth = 60.0,
    this.padding = 8.0,
    this.cornerRadius = 8.0,
    this.borderWidth = 1.5,
    this.fontSizeSp = 14.0,
    this.gradeFontSizeSp = 12.0,
    this.fontScale = 1.0,
    this.showSidebar = true,
    this.showGradeBox = true,
    this.primaryColor = Colors.blue,
    this.accentColor = Colors.amber,
  });
}
