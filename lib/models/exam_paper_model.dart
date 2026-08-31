import 'package:flutter/material.dart';

enum HeaderStyle { ovalTriple, modernMinimal, republicEmblem }

class ExamHeaderData {
  String republic;
  String ministry;
  String directorate;
  String schoolName;
  String subject;
  String grade;
  String examType;
  String section;
  String date;
  String duration;
  String academicYear;
  HeaderStyle style;
  bool showEmblem;

  ExamHeaderData({
    this.republic = 'الجمهورية اليمنية',
    this.ministry = 'وزارة التربية والتعليم',
    this.directorate = 'مكتب التربية والتعليم',
    this.schoolName = 'مدرسة النهضة الحديثة',
    this.subject = 'اللغة العربية',
    this.grade = 'الأول الثانوي',
    this.examType = 'اختبار الشهر الثاني',
    this.section = 'أ',
    this.date = '2026 / 5 / 10 م',
    this.duration = 'ساعتان',
    this.academicYear = '2025 - 2026 م',
    this.style = HeaderStyle.republicEmblem,
    this.showEmblem = true,
  });
}

class QuestionItem {
  String id;
  String number;
  String title;
  List<String> subItems;
  double grade;
  double fontSize;
  bool isBold;
  bool isItalic;
  bool isUnderline;

  QuestionItem({
    required this.id,
    required this.number,
    required this.title,
    required this.subItems,
    this.grade = 1.0,
    this.fontSize = 11.0,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
  });
}
