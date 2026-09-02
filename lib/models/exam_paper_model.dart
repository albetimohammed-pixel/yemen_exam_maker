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
  String day;
  String grade;
  String section;
  String date;
  String duration;
  bool showEmblem;
  HeaderStyle style;

  ExamHeaderData({
    this.republic = 'الجمهورية اليمنية',
    this.ministry = 'وزارة التربية والتعليم',
    this.directorate = 'مديرية المكلا',
    this.schoolName = 'ثانوية المكلا النموذجية للبنين',
    this.examType = 'اختبار الشهري الثاني الفصل الدراسي الثاني',
    this.academicYear = '2025 - 2026م',
    this.subject = 'المجتمع',
    this.day = 'الاثنين',
    this.grade = 'الصف الأول الثانوي',
    this.section = '',
    this.date = '2026/4/20م',
    this.duration = 'حصة',
    this.showEmblem = true,
    this.style = HeaderStyle.ovalTriple,
  });
}

enum QuestionType { text, multipleChoice, trueFalse, table }

// فقرة فرعية داخل السؤال (مثل أ، ب، ج)
class SubQuestionPart {
  String label; // مثلاً: أ)، ب)، ج)
  String text;  // نص الفقرة
  double score; // درجة هذه الفقرة

  SubQuestionPart({
    required this.label,
    required this.text,
    required this.score,
  });
}

class QuestionItem {
  String id;
  String questionNumber; // رقم السؤال (مثل 1)
  String instruction;    // التوجيه (مثل: * اجب عن جميع الأسئلة الآتية :)
  QuestionType type;
  String title;          // نص السؤال العام
  double score;          // الدرجة الكلية

  bool isBold;
  bool isItalic;
  bool isUnderline;

  int answerLines;
  List<String> options;
  List<String> statements;
  List<List<String>> tableData;

  // فقرات السؤال الفرعية (التي تظهر في الجدول)
  List<SubQuestionPart> parts;

  QuestionItem({
    required this.id,
    this.questionNumber = '1',
    this.instruction = '* اجب عن جميع الأسئلة الآتية :',
    this.type = QuestionType.text,
    this.title = '',
    this.score = 20.0,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.answerLines = 3,
    List<String>? options,
    List<String>? statements,
    List<List<String>>? tableData,
    List<SubQuestionPart>? parts,
  })  : options = options ?? ['الخيار الأول', 'الخيار الثاني'],
        statements = statements ?? ['العبارة الأولى', 'العبارة الثانية'],
        tableData = tableData ??
            [
              ['م', 'العنصر', 'البيان'],
              ['1', 'بيان 1', 'بيان 2']
            ],
        parts = parts ?? [];
}

// نموذج الاختبار المحفوظ
class SavedExamModel {
  String id;
  String title;
  DateTime dateSaved;
  ExamHeaderData headerData;
  List<QuestionItem> questions;

  SavedExamModel({
    required this.id,
    required this.title,
    required this.dateSaved,
    required this.headerData,
    required this.questions,
  });
}

// مدير تخزين الاختبارات المحفوظة
class ExamStorage {
  static final List<SavedExamModel> savedExams = [];

  static void saveExam(SavedExamModel exam) {
    int existingIndex = savedExams.indexWhere((e) => e.id == exam.id);
    if (existingIndex >= 0) {
      savedExams[existingIndex] = exam;
    } else {
      savedExams.insert(0, exam);
    }
  }

  static void deleteExam(String id) {
    savedExams.removeWhere((e) => e.id == id);
  }
}
