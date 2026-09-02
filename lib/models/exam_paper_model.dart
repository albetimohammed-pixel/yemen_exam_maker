import 'package:flutter/material.dart';

enum HeaderStyle { republicEmblem, ovalTriple, modernMinimal }

class ExamHeaderData {
  String republic;
  String ministry;
  String directorate;
  String schoolName;
  String examType;
  String academicYear;
  String subject;
  String grade;
  String section;
  String date;
  String duration;
  bool showEmblem;
  HeaderStyle style;

  ExamHeaderData({
    this.republic = 'الجمهورية اليمنية',
    this.ministry = 'وزارة التربية والتعليم',
    this.directorate = 'مكتب التربية والتعليم',
    this.schoolName = 'مدرسة الأمل النموذجية',
    this.examType = 'اختبار الفصل الدراسي الأول',
    this.academicYear = '2025 - 2026م',
    this.subject = 'الرياضيات',
    this.grade = 'التاسع الأساسي',
    this.section = 'أ',
    this.date = '2026/01/15',
    this.duration = 'ساعتان',
    this.showEmblem = true,
    this.style = HeaderStyle.republicEmblem,
  });
}

// أنواع الأسئلة المتاحة
enum QuestionType { text, multipleChoice, trueFalse, table }

class QuestionItem {
  String id;
  QuestionType type;
  String title; // نص السؤال
  double score; // الدرجة

  // أدوات التنسيق
  bool isBold;
  bool isItalic;
  bool isUnderline;

  // خصائص السؤال النصي
  int answerLines; // عدد أسطر الإجابة

  // خصائص سؤال اختر الإجابة الصحيحة
  List<String> options;

  // خصائص سؤال صح أو خطأ
  List<String> statements;

  // خصائص سؤال الجدول
  int tableRows;
  int tableCols;
  List<List<String>> tableData;

  QuestionItem({
    required this.id,
    this.type = QuestionType.text,
    this.title = '',
    this.score = 5.0,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.answerLines = 3,
    List<String>? options,
    List<String>? statements,
    int? tableRows,
    int? tableCols,
    List<List<String>>? tableData,
  })  : options = options ?? ['الخيار الأول', 'الخيار الثاني', 'الخيار الثالث'],
        statements = statements ?? ['العبارة الأولى', 'العبارة الثانية'],
        tableData = tableData ??
            [
              ['م', 'العنصر الأول', 'العنصر الثاني'],
              ['1', 'بيان 1', 'بيان 2']
            ],
        tableRows = tableRows ?? (tableData != null ? tableData.length : 2),
        tableCols = tableCols ?? (tableData != null && tableData.isNotEmpty ? tableData[0].length : 3);
}
