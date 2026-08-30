import 'package:flutter/material.dart';

// 1. نموذج بيانات الكليشة (الترويسة العلوية)
class ExamHeaderData {
  String country;
  String ministry;
  String directorate;
  String schoolName;
  String subject;
  String grade;
  String examTime;
  String teacherName;
  String semester;
  bool showBasmala;
  int templateType; // 0: 3 أعمدة, 1: جدول محدد, 2: شعار في المنتصف

  ExamHeaderData({
    this.country = 'جمهورية اليمن',
    this.ministry = 'وزارة التربية والتعليم',
    this.directorate = 'مكتب التربية والتعليم',
    this.schoolName = 'مدرسة الأمل النموذجية',
    this.subject = 'الرياضيات',
    this.grade = 'الصف الثالث الثانوي',
    this.examTime = 'ساعتان',
    this.teacherName = 'أ. أحمد علي',
    this.semester = 'اختبار نهاية الفصل الدراسي الأول',
    this.showBasmala = true,
    this.templateType = 0,
  });
}

// 2. نموذج بيانات جدول الأسئلة (مقارنة / توصيل / فارغ)
class ExamTableData {
  int rows;
  int cols;
  List<String> headers;
  List<List<String>> cells;

  ExamTableData({
    this.rows = 2,
    this.cols = 2,
    List<String>? headers,
    List<List<String>>? cells,
  })  : headers = headers ?? ['العمود (أ)', 'العمود (ب)'],
        cells = cells ??
            [
              ['', ''],
              ['', '']
            ];
}

// 3. نموذج تنسيق النص المتقدم (Bold, Italic, Underline)
class TextStyleConfig {
  bool isBold;
  bool isItalic;
  bool isUnderline;
  double fontSize;
  Color color;

  TextStyleConfig({
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.fontSize = 14.0,
    this.color = Colors.black,
  });

  TextStyle toTextStyle() {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontSize: fontSize,
      color: color,
    );
  }
}

// 4. نموذج تذييل الصفحة (الختام)
class ExamFooterData {
  String teacherSignature;
  String wishText;

  ExamFooterData({
    this.teacherSignature = 'معلم المادة: أ. أحمد علي',
    this.wishText = 'مع تمنياتي لكم بالتوفيق والنجاح',
  });
}

