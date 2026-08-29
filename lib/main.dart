import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ExamHomeScreen(),
    );
  }
}

enum QuestionType { essay, matching }

class MatchingPair {
  String itemA;
  String itemB;
  MatchingPair({required this.itemA, required this.itemB});
}

class QuestionItem {
  String questionNum; // 1, 2...
  String subLetter;   // أ, ب...
  String text;        // نص السؤال
  int mark;           // الدرجة
  int blankLines;     // عدد أسطر الفراغ
  QuestionType type;  // نوع السؤال
  List<MatchingPair> matchingPairs;

  QuestionItem({
    required this.questionNum,
    required this.subLetter,
    required this.text,
    required this.mark,
    this.blankLines = 1,
    this.type = QuestionType.essay,
    this.matchingPairs = const [],
  });
}

class ExamHomeScreen extends StatefulWidget {
  const ExamHomeScreen({super.key});

  @override
  State<ExamHomeScreen> createState() => _ExamHomeScreenState();
}

class _ExamHomeScreenState extends State<ExamHomeScreen> {
  // بيانات الترويسة
  final _schoolController = TextEditingController(text: 'ثانوية المكلا النموذجية للبنين');
  final _directorateController = TextEditingController(text: 'مديرية المكلا');
  final _examTitleController = TextEditingController(text: 'اختبار الشهري الثاني الفصل الدراسي الثاني');
  final _yearGradeController = TextEditingController(text: 'للصف الأول الثانوي - للعام 2025-2026م');
  final _subjectController = TextEditingController(text: 'المجتمع');
  final _dayController = TextEditingController(text: 'الاثنين');
  final _dateController = TextEditingController(text: '2026/4/20م');
  final _timeController = TextEditingController(text: 'حصة');

  final List<QuestionItem> _questions = [];

  // متحكمات إضافة سؤال جديد
  QuestionType _selectedType = QuestionType.essay;
  final _qNumController = TextEditingController();
  final _subLetterController = TextEditingController();
  final _qTextController = TextEditingController();
  final _markController = TextEditingController(text: '5');
  int _linesCount = 2;
  bool _isScanning = false;

  // متحكمات جدول التوصيل
  final List<TextEditingController> _colAControllers = [];
  final List<TextEditingController> _colBControllers = [];

  // ميزة مسح النص بالكاميرا (OCR)
  Future<void> _scanTextFromCamera(StateSetter setModalState) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    setModalState(() => _isScanning = true);

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setModalState(() {
        _qTextController.text = recognizedText.text;
        _isScanning = false;
      });

      textRecognizer.close();
    } catch (e) {
      setModalState(() => _isScanning = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء التعرف على النص: $e')),
        );
      }
    }
  }

  void _addPairField() {
    setState(() {
      _colAControllers.add(TextEditingController());
      _colBControllers.add(TextEditingController());
    });
  }

  void _removePairField(int index) {
    setState(() {
      _colAControllers.removeAt(index);
      _colBControllers.removeAt(index);
    });
  }

  void _addQuestion() {
    if (_qTextController.text.trim().isEmpty) return;

    List<MatchingPair> pairs = [];
    if (_selectedType == QuestionType.matching) {
      for (int i = 0; i < _colAControllers.length; i++) {
        if (_colAControllers[i].text.isNotEmpty || _colBControllers[i].text.isNotEmpty) {
          pairs.add(MatchingPair(
            itemA: _colAControllers[i].text,
            itemB: _colBControllers[i].text,
          ));
        }
      }
    }

    setState(() {
      _questions.add(
        QuestionItem(
          questionNum: _qNumController.text,
          subLetter: _subLetterController.text,
          text: _qTextController.text,
          mark: int.tryParse(_markController.text) ?? 5,
          blankLines: _linesCount,
          type: _selectedType,
          matchingPairs: pairs,
        ),
      );
    });

    _resetForm();
    Navigator.pop(context);
  }

  void _resetForm() {
    _qNumController.clear();
    _subLetterController.clear();
    _qTextController.clear();
    _colAControllers.clear();
    _colBControllers.clear();
    _selectedType = QuestionType.essay;
  }

  void _showAddDialog() {
    _resetForm();
    _addPairField();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20, left: 20, right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('إضافة سؤال جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 10),

                  SegmentedButton<QuestionType>(
                    segments: const [
                      ButtonSegment(value: QuestionType.essay, label: Text('سؤال عادي / مقالي')),
                      ButtonSegment(value: QuestionType.matching, label: Text('جدول توصيل (صل)')),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (newSelection) {
                      setModalState(() {
                        _selectedType = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(child: TextField(controller: _qNumController, decoration: const InputDecoration(labelText: 'رقم السؤال (1، 2..)'))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: _subLetterController, decoration: const InputDecoration(labelText: 'رمز الفقرة (أ، ب..)'))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: _markController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الدرجة'))),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // زر تصوير السؤال بالكاميرا
                  OutlinedButton.icon(
                    onPressed: _isScanning ? null : () => _scanTextFromCamera(setModalState),
                    icon: _isScanning
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.camera_alt, color: Colors.teal),
                    label: Text(_isScanning ? 'جاري القراءة...' : '📷 مسح السؤال بالكاميرا من كتاب/ورقة'),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _qTextController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: _selectedType == QuestionType.matching ? 'توجيه السؤال (صل العمود أ بـ ب)' : 'نص السؤال / الفقرة',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (_selectedType == QuestionType.essay) ...[
                    Row(
                      children: [
                        const Text('أسطر الإجابة الفارغة: '),
                        DropdownButton<int>(
                          value: _linesCount,
                          items: List.generate(6, (i) => DropdownMenuItem(value: i, child: Text('$i أسطر'))),
                          onChanged: (v) => setModalState(() => _linesCount = v ?? 2),
                        ),
                      ],
                    ),
                  ],

                  if (_selectedType == QuestionType.matching) ...[
                    const Divider(),
                    const Text('عناصر جدول التوصيل:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _colAControllers.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Text('${i + 1}- '),
                              Expanded(child: TextField(controller: _colAControllers[i], decoration: const InputDecoration(labelText: 'العمود (أ)', isDense: true, border: OutlineInputBorder()))),
                              const SizedBox(width: 8),
                              Expanded(child: TextField(controller: _colBControllers[i], decoration: const InputDecoration(labelText: 'العمود (ب)', isDense: true, border: OutlineInputBorder()))),
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => setModalState(() => _removePairField(i)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    TextButton.icon(
                      onPressed: () => setModalState(() => _addPairField()),
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة صف توصيل جديد'),
                    ),
                  ],

                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.check),
                    label: const Text('إضافة للاختبار'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // تصدير PDF
  Future<void> _exportPdf() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();
    const arabicLetters = ['أ', 'ب', 'ج', 'د', 'هـ', 'و', 'ز', 'ح', 'ط', 'ي'];

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
                // 1. الترويسة
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1.5),
                    borderRadius: pw.BorderRadius.circular(15),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
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

                // 3. جدول الأسئلة
                pw.Expanded(
                  child: pw.Table(
                    border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(40),
                      1: const pw.FlexColumnWidth(),
                      2: const pw.FixedColumnWidth(45),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(padding: const pw.EdgeInsets.all(4), alignment: pw.Alignment.center, child: pw.Text('الدرجة', style: pw.TextStyle(font: fontBold, fontSize: 11))),
                          pw.Container(padding: const pw.EdgeInsets.all(4), alignment: pw.Alignment.centerRight, child: pw.Text('* اجب عن جميع الأسئلة الآتية :', style: pw.TextStyle(font: fontBold, fontSize: 11))),
                          pw.Container(padding: const pw.EdgeInsets.all(4), alignment: pw.Alignment.center, child: pw.Text('السؤال', style: pw.TextStyle(font: fontBold, fontSize: 11))),
                        ],
                      ),
                      ..._questions.map((q) {
                        return pw.TableRow(
                          children: [
                            pw.Container(padding: const pw.EdgeInsets.all(8), alignment: pw.Alignment.center, child: pw.Text('${q.mark}', style: pw.TextStyle(font: fontBold, fontSize: 12))),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('${q.subLetter}) ${q.text}', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                                  if (q.type == QuestionType.essay && q.blankLines > 0)
                                    ...List.generate(
                                      q.blankLines,
                                      (index) => pw.Container(
                                        margin: const pw.EdgeInsets.only(top: 20),
                                        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey700))),
                                      ),
                                    ),
                                  if (q.type == QuestionType.matching && q.matchingPairs.isNotEmpty) ...[
                                    pw.SizedBox(height: 6),
                                    pw.Table(
                                      border: pw.TableBorder.all(width: 0.8, color: PdfColors.black),
                                      columnWidths: {0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(1)},
                                      children: [
                                        pw.TableRow(
                                          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                                          children: [
                                            pw.Container(padding: const pw.EdgeInsets.all(4), alignment: pw.Alignment.center, child: pw.Text('العمود ( ب )', style: pw.TextStyle(font: fontBold, fontSize: 10))),
                                            pw.Container(padding: const pw.EdgeInsets.all(4), alignment: pw.Alignment.center, child: pw.Text('العمود ( أ )', style: pw.TextStyle(font: fontBold, fontSize: 10))),
                                          ],
                                        ),
                                        ...q.matchingPairs.asMap().entries.map((entry) {
                                          int idx = entry.key;
                                          MatchingPair pair = entry.value;
                                          String letter = idx < arabicLetters.length ? arabicLetters[idx] : '${idx + 1}';
                                          return pw.TableRow(
                                            children: [
                                              pw.Container(padding: const pw.EdgeInsets.all(5), alignment: pw.Alignment.centerRight, child: pw.Text('(    ) $letter - ${pair.itemB}', style: pw.TextStyle(font: font, fontSize: 10))),
                                              pw.Container(padding: const pw.EdgeInsets.all(5), alignment: pw.Alignment.centerRight, child: pw.Text('${idx + 1} - ${pair.itemA}', style: pw.TextStyle(font: font, fontSize: 10))),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            pw.Container(padding: const pw.EdgeInsets.all(8), alignment: pw.Alignment.center, child: pw.Text(q.questionNum, style: pw.TextStyle(font: fontBold, fontSize: 14))),
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

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
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
                  label: const Text('إضافة سؤال / مسح بالكاميرا'),
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
                    leading: CircleAvatar(
                      backgroundColor: q.type == QuestionType.matching ? Colors.orange.shade100 : Colors.teal.shade100,
                      child: Icon(q.type == QuestionType.matching ? Icons.table_chart : Icons.short_text),
                    ),
                    title: Text(q.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('النوع: ${q.type == QuestionType.matching ? "جدول توصيل" : "سؤال مقالي"} | الدرجة: ${q.mark}'),
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
