import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const ExamApp());
}

class ExamApp extends StatelessWidget {
  const ExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منشئ الاختبارات اليمنية',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'YE'),
      supportedLocales: const [Locale('ar', 'YE')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFFAFAFAF),
      ),
      home: const ExamFormScreen(),
    );
  }
}

class QuestionModel {
  String text;
  String type; // 'اختيار من متعدد', 'صح أم خطأ', 'مقالي'
  List<String> options;
  String points;

  QuestionModel({
    required this.text,
    required this.type,
    this.options = const [],
    this.points = '1',
  });
}

class ExamFormScreen extends StatefulWidget {
  const ExamFormScreen({super.key});

  @override
  State<ExamFormScreen> createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  final _schoolController = TextEditingController(text: 'مدرسة النهضة الثانوية');
  final _subjectController = TextEditingController(text: 'الرياضيات');
  final _teacherController = TextEditingController(text: 'أ. محمد أحمد');
  final _timeController = TextEditingController(text: 'ساعة ونصف');
  final _scoreController = TextEditingController(text: '20');
  final _dateController = TextEditingController(text: '2026 / 5 / 10');
  
  String _examType = 'شهري';
  String _grade = 'الثالث الثانوي';

  final List<QuestionModel> _questions = [];

  void _addQuestionDialog() {
    final qTextController = TextEditingController();
    final pointsController = TextEditingController(text: '2');
    String qType = 'اختيار من متعدد';
    final opt1 = TextEditingController();
    final opt2 = TextEditingController();
    final opt3 = TextEditingController();
    final opt4 = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('إضافة سؤال جديد'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: qType,
                    decoration: const InputDecoration(labelText: 'نوع السؤال'),
                    items: ['اختيار من متعدد', 'صح أم خطأ', 'مقالي']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) => setDialogState(() => qType = val!),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: qTextController,
                    decoration: const InputDecoration(labelText: 'نص السؤال', border: OutlineInputBorder()),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: pointsController,
                    decoration: const InputDecoration(labelText: 'درجة السؤال', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                  if (qType == 'اختيار من متعدد') ...[
                    const SizedBox(height: 10),
                    TextField(controller: opt1, decoration: const InputDecoration(labelText: 'خيار أ')),
                    TextField(controller: opt2, decoration: const InputDecoration(labelText: 'خيار ب')),
                    TextField(controller: opt3, decoration: const InputDecoration(labelText: 'خيار ج')),
                    TextField(controller: opt4, decoration: const InputDecoration(labelText: 'خيار د')),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (qTextController.text.isNotEmpty) {
                    List<String> opts = [];
                    if (qType == 'اختيار من متعدد') {
                      opts = [opt1.text, opt2.text, opt3.text, opt4.text]
                          .where((element) => element.isNotEmpty)
                          .toList();
                    }
                    setState(() {
                      _questions.add(QuestionModel(
                        text: qTextController.text,
                        type: qType,
                        options: opts,
                        points: pointsController.text,
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('إضافة'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منشئ الاختبارات اليمنية'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ترويسة معلومات المدرسة
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('بيانات الترويسة الرسمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),
                    TextField(
                      controller: _schoolController,
                      decoration: const InputDecoration(labelText: 'اسم المدرسة'),
                    ),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _subjectController, decoration: const InputDecoration(labelText: 'المادة'))),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _grade,
                            decoration: const InputDecoration(labelText: 'الصف'),
                            items: ['الأول الثانوي', 'الثاني الثانوي', 'الثالث الثانوي']
                                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                .toList(),
                            onChanged: (val) => setState(() => _grade = val!),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _examType,
                            decoration: const InputDecoration(labelText: 'نوع الاختبار'),
                            items: ['شهري', 'فصلي', 'تجريبي']
                                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (val) => setState(() => _examType = val!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _teacherController, decoration: const InputDecoration(labelText: 'اسم المعلم'))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _timeController, decoration: const InputDecoration(labelText: 'زمن الاختبار'))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _scoreController, decoration: const InputDecoration(labelText: 'الدرجة الكلية'))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: _dateController, decoration: const InputDecoration(labelText: 'التاريخ'))),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // قائمة الأسئلة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الأسئلة المُضافة (${_questions.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ElevatedButton.icon(
                  onPressed: _addQuestionDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة سؤال'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (ctx, idx) {
                final q = _questions[idx];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${idx + 1}')),
                    title: Text(q.text),
                    subtitle: Text('النوع: ${q.type} - الدرجة: ${q.points}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _questions.removeAt(idx)),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // زر معاينة وتصدير PDF
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_questions.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إضافة سؤال واحد على الأقل قبل المعاينة')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPreviewScreen(
                      school: _schoolController.text,
                      subject: _subjectController.text,
                      teacher: _teacherController.text,
                      time: _timeController.text,
                      score: _scoreController.text,
                      date: _dateController.text,
                      examType: _examType,
                      grade: _grade,
                      questions: _questions,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('معاينة وتصدير الاختبار (PDF / صورة)', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfPreviewScreen extends StatelessWidget {
  final String school, subject, teacher, time, score, date, examType, grade;
  final List<QuestionModel> questions;

  const PdfPreviewScreen({
    super.key,
    required this.school,
    required this.subject,
    required this.teacher,
    required this.time,
    required this.score,
    required this.date,
    required this.examType,
    required this.grade,
    required this.questions,
  });

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ترويسة الاختبار الرسمية
              pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.5)),
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'الجمهورية اليمنية - وزارة التربية والتعليم',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('مدرسة: $school'),
                        pw.Text('المادة: $subject'),
                        pw.Text('الصف: $grade'),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('نوع الاختبار: $examType'),
                        pw.Text('الزمن: $time'),
                        pw.Text('الدرجة الكلية: $score'),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('معلم المادة: $teacher'),
                        pw.Text('التاريخ: $date'),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('اسم الطالب: ..........................................................................................................'),
              pw.SizedBox(height: 5),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // عرض الأسئلة
              ...questions.asMap().entries.map((entry) {
                int index = entry.key + 1;
                QuestionModel q = entry.value;
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 14),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'س$index: ${q.text}  (${q.points} درجات)',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                      ),
                      if (q.type == 'اختيار من متعدد' && q.options.isNotEmpty) ...[
                        pw.SizedBox(height: 6),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: q.options.asMap().entries.map((optEntry) {
                            final labels = ['أ', 'ب', 'ج', 'د'];
                            String label = optEntry.key < labels.length ? labels[optEntry.key] : '';
                            return pw.Text('$label) ${optEntry.value}');
                          }).toList(),
                        ),
                      ],
                      if (q.type == 'صح أم خطأ') ...[
                        pw.SizedBox(height: 6),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text('   (   ) صحيح   '),
                            pw.SizedBox(width: 40),
                            pw.Text('   (   ) خطأ   '),
                          ],
                        ),
                      ],
                      if (q.type == 'مقالي') ...[
                        pw.SizedBox(height: 12),
                        pw.Text('الإجابة: ............................................................................................................................................'),
                      ],
                    ],
                  ),
                );
              }),

              pw.Spacer(),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'مع تمنياتنا لكم بالتوفيق والنجاح',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة ورقة الاختبار وتصديرها'),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        pdfFileName: 'اختبار_$subject.pdf',
      ),
    );
  }
}
