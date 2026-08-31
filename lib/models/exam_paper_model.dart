import 'package:flutter/material.dart';

// 1. نموذج السؤال
class QuestionItem {
  String id;
  String number; // رقم أو رمز السؤال (مثل: س1 أو أ)
  String title; // نص السؤال الرئيسي
  List<String> subItems; // الفقرات/النقاط الفرعية
  int grade; // الدرجة
  bool isBold;
  bool isItalic;
  bool isUnderline;
  double fontSize;

  QuestionItem({
    required this.id,
    required this.number,
    required this.title,
    this.subItems = const [],
    this.grade = 0,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.fontSize = 12.0,
  });
}

// 2. نموذج الكليشة اليمنية الرسمية (ثانوية المكلا النموذجية)
class YemeniHeaderModel {
  String subject;
  String day;
  String date;
  String examTitle;
  String gradeLevel;
  String academicYear;
  String schoolName;
  String directorate;
  String duration;
  String teacherName;

  YemeniHeaderModel({
    this.subject = 'المجتمع',
    this.day = 'الاثنين',
    this.date = '2026/04/20م',
    this.examTitle = 'اختبار الشهري الثاني الفصل الدراسي الثاني',
    this.gradeLevel = 'للصف الأول الثانوي',
    this.academicYear = 'للعام 2025-2026م',
    this.schoolName = 'ثانوية المكلا النموذجية للبنين',
    this.directorate = 'مديرية المكلا',
    this.duration = 'حصة',
    this.teacherName = 'أ. أحمد علي',
  });
}

// 3. نموذج حفظ الاختبارات الشامل
class SavedExamModel {
  String id;
  String title;
  String date;
  YemeniHeaderModel header;
  List<QuestionItem> questions;

  SavedExamModel({
    required this.id,
    required this.title,
    required this.date,
    required this.header,
    required this.questions,
  });
}

