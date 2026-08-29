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

class QuestionItem {
  String questionNum; // 1, 2, 3...
  String subLetter;   // أ, ب, ج...
  String text;        // نص السؤال
  int mark;           // الدرجة (مثلاً 6)
  int blankLines;     // عدد أسطر الإجابة أو الفراغات

  QuestionItem({
    required this.questionNum,
    required this.subLetter,
    required this.text,
    required this.mark,
    this.blankLines = 1,
  });
}

class ExamHomeScreen extends StatefulWidget {
  const ExamHomeScreen({super.key});

  @override
  State<ExamHomeScreen> createState() => _ExamHomeScreenState();
}

class _ExamHomeScreenState extends State<ExamHomeScreen> {
  // بيانات الترويسة من الصورة
  final _schoolController = TextEditingController(text: 'ثانوية المكلا النموذجية للبنين');
  final _directorateController = TextEditingController(text: 'مديرية المكلا');
  final _examTitleController = TextEditingController(text: 'اختبار الشهري الثاني الفصل الدراسي الثاني');
  final _yearGradeController = TextEditingController(text: 'للصف الأول الثانوي - للعام 2025-2026م');
  final _subjectController = TextEditingController(text: 'المجتمع');
  final _dayController = TextEditingController(text: 'الاثنين');
  final _dateController = TextEditingController(text: '2026/4/20م');
  final _timeController = TextEditingController(text: 'حصة');

  final List<QuestionItem> _questions = [
    QuestionItem(
      questionNum: '1',
      subLetter: 'أ',
      text: 'أكمل الفراغات الآتية بالكلمات المناسبة فيما يلي:\n1- يتحقق العدل داخل المجتمع من خلال العناية بـ _______________________\n2- الشعب بدورة يجعل السكان هم العنصر الأساسي لـ _______________________\n3- الحصول على القروض والمساعدات التي تمكن الدول من أن تخطو خطوات واسعة في _______________________',
      mark: 6,
      blankLines: 0,
    ),
    QuestionItem(
      questionNum: '',
      subLetter: 'ب',
      text: 'ما دور الدولة في تطوير المياه والصرف الصحي؟',
      mark: 6,
      blankLines: 2,
    ),
    QuestionItem(
      questionNum: '',
      subLetter: 'ج',
      text: 'ناقش العبارة الاتية: (حكومة الديمقراطية هي حكومة الأغلبية).',
      mark: 4,
      blankLines: 2,
    ),
    QuestionItem(
      questionNum: '',
      subLetter: 'د',
      text: 'ماذا حصل مع بداية الخمسينات من القرن العشرين لحركة المعارضة ضد الاستعمار البريطاني؟',
      mark: 4,
      blankLines: 2,
    ),
  ];

  final _qNumController = TextEditingController();
  final _subLetterController = TextEditingController();
  final _qTextController = TextEditingController();
  final _markController = TextEditingController(text: '5');
  int _linesCount = 2;

  void _addQuestion() {
    if (_qTextController.text.trim().isEmpty) return;

    setState(() {
      _questions.add(
        QuestionItem(
          questionNum: _qNumController.text,
          subLetter: _subLetterController.text,
          text: _qTextController.text,
          mark: int.tryParse(_markController.text) ?? 5,
          blankLines: _linesCount,
        ),
      );
    });

    _qNumController.clear();
    _subLetterController.clear();
    _qTextController.clear();
    Navigator.pop(context);
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20, left: 20, right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('إضافة فقرة / سؤال جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _qNumController, decoration: const InputDecoration(labelText: 'رقم السؤال (مثال: 1)'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _subLetterController, decoration: const InputDecoration(labelText: 'رمز الفقرة (مثال: أ)'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _markController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الدرجة'))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _qTextController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'نص السؤال / الفقرة', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: const Text('إضافة للاختبار'),
            )
          ],
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
        margin: const pw.EdgeInsets.all(15),
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 2, color: PdfColors.black),
            ),
            child: pw.Column(
              children: [
                // 1. الترويسة الرسمية الثلاثية (طابق الصورة تماماً)
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1.5),
                    borderRadius: pw.BorderRadius.circular(15),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      // اليمين: المدرسة والمديرية والزمن
                      pw.Container(
                        width: 150,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(_schoolController.text, style: pw.TextStyle(font: fontBold, fontSize: 10)),
                            pw.Text(_directorateController.text, style: pw.TextStyle(font: font, fontSize: 9)),
                            pw.Text('الزمن : ${_timeController.text}', style: pw.TextStyle(font: font, fontSize: 9)),
                          ],
                        ),
                      ),
                      // الوسط: الشكل البيضاوي لعنوان الاختبار
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1.5),
                          borderRadius: pw.BorderRadius.all(pw.Radius.elliptical(100, 50)),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Text(_examTitleController.text, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                            pw.SizedBox(height: 2),
                            pw.Text(_yearGradeController.text, style: pw.TextStyle(font: font, fontSize: 9)),
                          ],
                        ),
                      ),
                      // اليسار: المادة واليوم والتاريخ
                      pw.Container(
                        width: 150,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text('المادة : ${_subjectController.text}', style: pw.TextStyle(font: fontBold, fontSize: 10)),
                            pw.Text('اليوم : ${_dayController.text}', style: pw.TextStyle(font: font, fontSize: 9)),
                            pw.Text('التاريخ : ${_dateController.text}', style: pw.TextStyle(font: font, fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 8),

                // 2. شريط بيانات الطالب
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('اسم الطالب : ............................................................................', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                    pw.Text('الشعبة (       )', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                  ],
                ),
                pw.SizedBox(height: 8),

                // 3. جدول الأسئلة مع خانة الدرجات ورقم السؤال
                pw.Expanded(
                  child: pw.Table(
                    border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(40),  // عمود الدرجة
                      1: const pw.FlexColumnWidth(),     // عمود السؤال والأسئلة
                      2: const pw.FixedColumnWidth(45),  // عمود رقم السؤال
                    },
                    children: [
                      // رأس الجدول
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(4),
                            alignment: pw.Alignment.center,
                            child: pw.Text('الدرجة', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(4),
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text('* اجب عن جميع الأسئلة الآتية :', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(4),
                            alignment: pw.Alignment.center,
                            child: pw.Text('السؤال', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                          ),
                        ],
                      ),
                      // صفوف الأسئلة
                      ..._questions.map((q) {
                        return pw.TableRow(
                          children: [
                            // خانة الدرجة
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              alignment: pw.Alignment.center,
                              child: pw.Text('${q.mark}', style: pw.TextStyle(font: fontBold, fontSize: 12)),
                            ),
                            // نص السؤال
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('${q.subLetter}) ${q.text}', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                                  if (q.blankLines > 0)
                                    ...List.generate(
                                      q.blankLines,
                                      (index) => pw.Container(
                                        margin: const pw.EdgeInsets.only(top: 25),
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey700)),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // رقم السؤال
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              alignment: pw.Alignment.center,
                              child: pw.Text(q.questionNum, style: pw.TextStyle(font: fontBold, fontSize: 14)),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
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
        title: const Text('صانع الاختبارات النموذجية'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportPdf,
            tooltip: 'تصدير PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: ExpansionTile(
                title: const Text('إعدادات الترويسة والمعلومات', style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextField(controller: _schoolController, decoration: const InputDecoration(labelText: 'اسم المدرسة')),
                        TextField(controller: _directorateController, decoration: const InputDecoration(labelText: 'المديرية')),
                        TextField(controller: _examTitleController, decoration: const InputDecoration(labelText: 'عنوان الاختبار')),
                        TextField(controller: _yearGradeController, decoration: const InputDecoration(labelText: 'الصف والعام الدراسي')),
                        Row(
                          children: [
                            Expanded(child: TextField(controller: _subjectController, decoration: const InputDecoration(labelText: 'المادة'))),
                            const SizedBox(width: 10),
                            Expanded(child: TextField(controller: _dayController, decoration: const InputDecoration(labelText: 'اليوم'))),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: TextField(controller: _dateController, decoration: const InputDecoration(labelText: 'التاريخ'))),
                            const SizedBox(width: 10),
                            Expanded(child: TextField(controller: _timeController, decoration: const InputDecoration(labelText: 'الزمن'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('قائمة الأسئلة (${_questions.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة سؤال'),
                ),
              ],
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (ctx, i) {
                final q = _questions[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(q.subLetter.isEmpty ? '${i + 1}' : q.subLetter)),
                    title: Text(q.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('الدرجة: ${q.mark} | رقم السؤال الرئيسي: ${q.questionNum}'),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportPdf,
        icon: const Icon(Icons.print),
        label: const Text('معاينة وطباعة الورقة الامتحانية (PDF)'),
      ),
    );
  }
}
