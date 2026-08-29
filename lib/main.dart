import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const YemenExamMakerApp());
}

class YemenExamMakerApp extends StatelessWidget {
  const YemenExamMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صانع الاختبارات اليمنية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExamHomeScreen(),
    );
  }
}

class Question {
  String title;
  String type; // اختيار من متعدد ، صح وخطأ ، مقالي
  List<String> options;

  Question({
    required this.title,
    required this.type,
    this.options = const [],
  });
}

class ExamHomeScreen extends StatefulWidget {
  const ExamHomeScreen({super.key});

  @override
  State<ExamHomeScreen> createState() => _ExamHomeScreenState();
}

class _ExamHomeScreenState extends State<ExamHomeScreen> {
  final _schoolController = TextEditingController(text: 'مدرسة النهضة الثانوية');
  final _subjectController = TextEditingController(text: 'العلوم العامة');
  final _gradeController = TextEditingController(text: 'الثالث الثانوي');
  final _timeController = TextEditingController(text: 'ساعتان');

  final List<Question> _questions = [];

  final _qTitleController = TextEditingController();
  String _selectedType = 'اختيار من متعدد';
  final _opt1Controller = TextEditingController();
  final _opt2Controller = TextEditingController();
  final _opt3Controller = TextEditingController();
  final _opt4Controller = TextEditingController();

  void _addQuestion() {
    if (_qTitleController.text.trim().isEmpty) return;

    List<String> opts = [];
    if (_selectedType == 'اختيار من متعدد') {
      if (_opt1Controller.text.isNotEmpty) opts.add(_opt1Controller.text);
      if (_opt2Controller.text.isNotEmpty) opts.add(_opt2Controller.text);
      if (_opt3Controller.text.isNotEmpty) opts.add(_opt3Controller.text);
      if (_opt4Controller.text.isNotEmpty) opts.add(_opt4Controller.text);
    }

    setState(() {
      _questions.add(
        Question(
          title: _qTitleController.text,
          type: _selectedType,
          options: opts,
        ),
      );
    });

    _qTitleController.clear();
    _opt1Controller.clear();
    _opt2Controller.clear();
    _opt3Controller.clear();
    _opt4Controller.clear();
    Navigator.pop(context);
  }

  void _showAddQuestionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'إضافة سؤال جديد',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                items: ['اختيار من متعدد', 'صح أم خطأ', 'سؤال مقالي']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => _selectedType = val);
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _qTitleController,
                decoration: const InputDecoration(
                  labelText: 'نص السؤال',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_selectedType == 'اختيار من متعدد') ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _opt1Controller,
                  decoration: const InputDecoration(labelText: 'الخيّار الأول'),
                ),
                TextField(
                  controller: _opt2Controller,
                  decoration: const InputDecoration(labelText: 'الخيّار الثاني'),
                ),
                TextField(
                  controller: _opt3Controller,
                  decoration: const InputDecoration(labelText: 'الخيّار الثالث'),
                ),
                TextField(
                  controller: _opt4Controller,
                  decoration: const InputDecoration(labelText: 'الخيّار الرابع'),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.check),
                label: const Text('حفظ السؤال'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // الهيدر علوي
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('المدرسة: ${_schoolController.text}', style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.Text('المادة: ${_subjectController.text}', style: pw.TextStyle(font: font, fontSize: 12)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('الصف: ${_gradeController.text}', style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.Text('الزمن: ${_timeController.text}', style: pw.TextStyle(font: font, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'اختبار مادة ${_subjectController.text}',
                  style: pw.TextStyle(font: fontBold, fontSize: 18),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),

              // الأسئلة
              ...List.generate(_questions.length, (index) {
                final q = _questions[index];
                return pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'س${index + 1}: ${q.title}',
                        style: pw.TextStyle(font: fontBold, fontSize: 14),
                      ),
                      if (q.type == 'اختيار من متعدد') ...[
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: q.options
                              .map((opt) => pw.Text('أ) $opt', style: pw.TextStyle(font: font, fontSize: 11)))
                              .toList(),
                        )
                      ] else if (q.type == 'صح أم خطأ') ...[
                        pw.SizedBox(height: 5),
                        pw.Text('(   ) صح     /     (   ) خطأ', style: pw.TextStyle(font: font, fontSize: 12)),
                      ] else ...[
                        pw.SizedBox(height: 20),
                        pw.Container(
                          height: 1,
                          color: PdfColors.grey300,
                        ),
                      ]
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صانع الاختبارات اليمنية'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _questions.isEmpty ? null : _exportPdf,
            tooltip: 'تصدير PDF',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _schoolController,
                            decoration: const InputDecoration(labelText: 'اسم المدرسة'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _subjectController,
                            decoration: const InputDecoration(labelText: 'المادة'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _gradeController,
                            decoration: const InputDecoration(labelText: 'الصف'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _timeController,
                            decoration: const InputDecoration(labelText: 'الزمن'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة الأسئلة (${_questions.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddQuestionDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة سؤال'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: _questions.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد أسئلة مضافة بعد.\nاضغط على "إضافة سؤال" للبدء!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (ctx, i) {
                        final q = _questions[i];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${i + 1}')),
                            title: Text(q.title),
                            subtitle: Text('نوع السؤال: ${q.type}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _questions.removeAt(i);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _questions.isEmpty ? null : _exportPdf,
        icon: const Icon(Icons.print),
        label: const Text('طباعة / تصدير PDF'),
      ),
    );
  }
}
