import 'package:flutter/material.dart';
import '../models/question_template_config.dart';
import '../models/watermark_config.dart';
import '../models/page_border_config.dart';

class EditorController extends ChangeNotifier {
  // نماذج البيانات الأساسية
  final QuestionTemplateConfig questionConfig = QuestionTemplateConfig();
  final WatermarkConfig watermarkConfig = WatermarkConfig();
  final PageBorderConfig borderConfig = PageBorderConfig();

  // إعدادات صفحة الإجابات النموذجية
  int tfQuestionCount = 5;
  int mcqQuestionCount = 10;
  String selectedLanguage = 'AR'; // 'AR' أو 'EN'

  // --- 1. عمليات ضبط شريط السؤال ---
  void updateQuestionBarWidth(double value) {
    questionConfig.barWidth = value;
    notifyListeners();
  }

  void updateQuestionCornerRadius(double value) {
    questionConfig.cornerRadius = value;
    notifyListeners();
  }

  void updateQuestionFontSize(double value) {
    questionConfig.fontSizeSp = value;
    notifyListeners();
  }

  void toggleShowSidebar(bool value) {
    questionConfig.showSidebar = value;
    notifyListeners();
  }

  void toggleShowGradeBox(bool value) {
    questionConfig.showGradeBox = value;
    notifyListeners();
  }

  void setQuestionPrimaryColor(Color color) {
    questionConfig.primaryColor = color;
    notifyListeners();
  }

  // --- 2. عمليات ضبط العلامة المائية ---
  void toggleWatermark(bool value) {
    watermarkConfig.isEnabled = value;
    notifyListeners();
  }

  void updateWatermarkOpacity(double value) {
    watermarkConfig.opacity = value;
    notifyListeners();
  }

  void updateWatermarkRotation(double value) {
    watermarkConfig.rotationDegree = value;
    notifyListeners();
  }

  void updateWatermarkSizePercentage(double value) {
    watermarkConfig.sizePercentage = value;
    notifyListeners();
  }

  // --- 3. عمليات ضبط الإطارات والحدود ---
  void toggleBorder(bool value) {
    borderConfig.isEnabled = value;
    notifyListeners();
  }

  void updateOuterBorderWidth(double value) {
    borderConfig.outerBorderWidth = value;
    notifyListeners();
  }

  void updateSpacing(double value) {
    borderConfig.spacing = value;
    notifyListeners();
  }

  void updateInnerBorderWidth(double value) {
    borderConfig.innerBorderWidth = value;
    notifyListeners();
  }

  void updateBorderCornerRadius(double value) {
    borderConfig.cornerRadius = value;
    notifyListeners();
  }

  void setOuterBorderColor(Color color) {
    borderConfig.outerBorderColor = color;
    notifyListeners();
  }

  // --- 4. عمليات ضبط صفحة الإجابة ---
  void setAnswerSheetCounts(int tf, int mcq) {
    tfQuestionCount = tf;
    mcqQuestionCount = mcq;
    notifyListeners();
  }

  void setLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }
}
