import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pwWidget;
import 'package:printing/printing.dart';

// ==========================================
// 1. نموذج بيانات السؤال (Question Model)
// ==========================================
enum QuestionType { text, mcq, trueFalse, table }

class Question {
  String id;
  String title;
  QuestionType type;
  double score;
  int answerLines;
  List<String> options;
  List<String> statements;
  int rows;
  int cols;
  List<List<String>> tableData;

  Question({
    required this.id,
    required this.title,
    required this.type,
    this.score = 1.0,
    this.answerLines = 3,
    this.options = const [],
    this.statements = const [],
    this.rows = 2,
    this.cols = 2,
    List<List<String>>? tableData,
  }) : tableData = tableData ?? List.generate(rows, (_) => List.filled(cols, ''));
}

// ==========================================
// 2. الشاشة الرئيسية (MainEditorScreen)
// ==========================================
class MainEditorScreen extends StatefulWidget {
  final dynamic initialExam;
  final dynamic exam;
  final dynamic title;
  final dynamic data;

  const MainEditorScreen({
    Key? key,
    this.initialExam,
    this.exam,
    this.title,
    this.data,
  }) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // controllers كليشة الاختبار المصغرة والمضغوطة
  final _schoolController = TextEditingController(text: 'ثانوية المكلا النموذجية للبنين\nمديرية المكلا');
  final _timeController = TextEditingController(text: 'الزمن : حصة');
  final _examTitleController = TextEditingController(text: 'اختبار الشهري الثاني الفصل الدراسي الثاني\nللصف الأول الثانوي - للعام 2025-2026م');
  final _subjectController = TextEditingController(text: 'المادة : المجتمع');
  final _dayController = TextEditingController(text: 'اليوم : الاثنين');
  final _dateController = TextEditingController(text: 'التاريخ : 2026/4/20م');

  final List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _schoolController.dispose();
    _timeController.dispose();
    _examTitleController.dispose();
    _subjectController.dispose();
    _dayController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // دالة التصدير الحقيقي كـ PDF مطابق تماماً للصورة الرسمية
  // --------------------------------------------------------------------------
  Future<void> _exportOrPrintExam() async {
    final pdf = pwWidget.Document();

    // تحميل خط عربي لضمان ظهور النصوص العربية بشكل صحيح في ملف الـ PDF
    var fontData = await PdfGoogleFonts.amiriRegular();
    var fontBold = await PdfGoogleFonts.amiriBold();

    pdf.addPage(
      pwWidget.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pwWidget.TextDirection.rtl,
        build: (pwWidget.Context context) {
          return pwWidget.Container(
            padding: const pwWidget.EdgeInsets.all(10),
            decoration: pwWidget.BoxDecoration(
              border: pwWidget.Border.all(color: pw.PdfColors.black, width: 1.2),
            ),
            child: pwWidget.Column(
              crossAxisAlignment: pwWidget.CrossAxisAlignment.stretch,
              children: [
                // ترويسة الاختبار
                pwWidget.Row(
                  mainAxisAlignment: pwWidget.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pwWidget.CrossAxisAlignment.start,
                  children: [
                    pwWidget.Column(
                      crossAxisAlignment: pwWidget.CrossAxisAlignment.start,
                      children: [
                        pwWidget.Text(_schoolController.text, style: pwWidget.TextStyle(font: fontBold, fontSize: 10)),
                        pwWidget.SizedBox(height: 2),
                        pwWidget.Text(_timeController.text, style: pwWidget.TextStyle(font: fontData, fontSize: 10)),
                      ],
                    ),
                    pwWidget.Container(
                      padding: const pwWidget.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: pwWidget.BoxDecoration(
                        border: pwWidget.Border.all(color: pw.PdfColors.black, width: 0.8),
                        borderRadius: const pwWidget.BorderRadius.all(pw.Radius.circular(15)),
                      ),
                      child: pwWidget.Text(
                        _examTitleController.text,
                        textAlign: pwWidget.TextAlign.center,
                        style: pwWidget.TextStyle(font: fontBold, fontSize: 9.5),
                      ),
                    ),
                    pwWidget.Column(
                      crossAxisAlignment: pwWidget.CrossAxisAlignment.end,
                      children: [
                        pwWidget.Text(_subjectController.text, style: pwWidget.TextStyle(font: fontBold, fontSize: 10)),
                        pwWidget.Text(_dayController.text, style: pwWidget.TextStyle(font: fontData, fontSize: 10)),
                        pwWidget.Text(_dateController.text, style: pwWidget.TextStyle(font: fontData, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                pwWidget.SizedBox(height: 6),
                pwWidget.Row(
                  mainAxisAlignment: pwWidget.MainAxisAlignment.spaceBetween,
                  children: [
                    pwWidget.Text('اسم الطالب : ________________________________________', style: pwWidget.TextStyle(font: fontBold, fontSize: 11)),
                    pwWidget.Text('الشعبة (     )', style: pwWidget.TextStyle(font: fontBold, fontSize: 11)),
                  ],
                ),
                pwWidget.Divider(color: pw.PdfColors.black, thickness: 1.2),
                pwWidget.SizedBox(height: 6),

                // جدول الأسئلة
                pwWidget.Table(
                  border: pwWidget.TableBorder.all(color: pw.PdfColors.black, width: 0.8),
                  columnWidths: const {
                    0: pwWidget.FlexColumnWidth(5.5),
                    1: pwWidget.FlexColumnWidth(0.8),
                  },
                  children: [
                    pwWidget.TableRow(
                      decoration: const pwWidget.BoxDecoration(color: pw.PdfColors.grey200),
                      children: [
                        pwWidget.Padding(
                          padding: const pwWidget.EdgeInsets.all(5.0),
                          child: pwWidget.Text(
                            '* أجب عن جميع الأسئلة الآتية :',
                            textAlign: pwWidget.TextAlign.center,
                            style: pwWidget.TextStyle(font: fontBold, fontSize: 11),
                          ),
                        ),
                        pwWidget.Padding(
                          padding: const pwWidget.EdgeInsets.all(5.0),
                          child: pwWidget.Text(
                            'الدرجة',
                            textAlign: pwWidget.TextAlign.center,
                            style: pwWidget.TextStyle(font: fontBold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    pwWidget.TableRow(
                      children: [
                        pwWidget.Padding(
                          padding: const pwWidget.EdgeInsets.all(6.0),
                          child: pwWidget.Column(
                            crossAxisAlignment: pwWidget.CrossAxisAlignment.start,
                            children: _questions.isEmpty
                                ? [pwWidget.Text('لا توجد أسئلة مضافة.', style: pwWidget.TextStyle(font: fontData))]
                                : _questions.asMap().entries.map((entry) {
                              return _buildPdfQuestionItem(entry.key + 1, entry.value, fontData, fontBold);
                            }).toList(),
                          ),
                        ),
                        pwWidget.Padding(
                          padding: const pwWidget.EdgeInsets.symmetric(vertical: 10.0),
                          child: pwWidget.Column(
                            mainAxisAlignment: pwWidget.MainAxisAlignment.spaceAround,
                            children: _questions.map((q) {
                              return pwWidget.Padding(
                                padding: const pwWidget.EdgeInsets.symmetric(vertical: 20.0),
                                child: pwWidget.Text('${q.score.toInt()}', style: pwWidget.TextStyle(font: fontBold, fontSize: 12)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // فتح نافذة طباعة / حفظ الـ PDF مباشرة في التطبيق
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pwWidget.Widget _buildPdfQuestionItem(int number, Question q, pwWidget.Font fontData, pwWidget.Font fontBold) {
    const arabicLetters = ['أ', 'ب', 'ج', 'د', 'هـ', 'و'];
    String letter = (number - 1 < arabicLetters.length) ? arabicLetters[number - 1] : '$number';

    return pwWidget.Padding(
      padding: const pwWidget.EdgeInsets.only(bottom: 12.0),
      child: pwWidget.Column(
        crossAxisAlignment: pwWidget.CrossAxisAlignment.start,
        children: [
          pwWidget.Text('$letter) ${q.title}', style: pwWidget.TextStyle(font: fontBold, fontSize: 11)),
          pwWidget.SizedBox(height: 4),
          if (q.type == QuestionType.text)
            ...List.generate(q.answerLines, (index) => pwWidget.Container(
              margin: const pwWidget.EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: const pwWidget.BoxDecoration(
                border: pwWidget.Border(bottom: pwWidget.BorderSide(color: pw.PdfColors.black, width: 0.6)),
              ),
              height: 16,
            ))
          else if (q.type == QuestionType.mcq)
            ...q.options.map((opt) => pwWidget.Padding(
              padding: const pwWidget.EdgeInsets.only(right: 10, bottom: 2),
              child: pwWidget.Text('• $opt', style: pwWidget.TextStyle(font: fontData, fontSize: 10)),
            ))
          else if (q.type == QuestionType.trueFalse)
            ...q.statements.map((stmt) => pwWidget.Padding(
              padding: const pwWidget.EdgeInsets.only(right: 10, bottom: 2),
              child: pwWidget.Row(
                mainAxisAlignment: pwWidget.MainAxisAlignment.spaceBetween,
                children: [
                  pwWidget.Text('• $stmt', style: pwWidget.TextStyle(font: fontData, fontSize: 10)),
                  pwWidget.Text('(   )', style: pwWidget.TextStyle(font: fontData, fontSize: 10)),
                ],
              ),
            )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('محرر الاختبارات الرسمي'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.print, color: Colors.white),
              tooltip: 'تصدير PDF / طباعة',
              onPressed: _exportOrPrintExam,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.description), text: 'بيانات الترويسة'),
              Tab(icon: Icon(Icons.list_alt), text: 'إدارة الأسئلة'),
              Tab(icon: Icon(Icons.print), text: 'معاينة ورقة الاختبار'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildHeaderTab(),
            _buildQuestionsTab(),
            _buildPreviewTab(),
          ],
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _tabController,
          builder: (context, child) {
            if (_tabController.index == 1) {
              return FloatingActionButton.extended(
                onPressed: () => _openQuestionDialog(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة سؤال جديد'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeaderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تعديل حقول كليشة الاختبار الرسمية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: _schoolController, maxLines: 2, decoration: const InputDecoration(labelText: 'بيانات المدرسة', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _timeController, decoration: const InputDecoration(labelText: 'الزمن', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _examTitleController, maxLines: 2, decoration: const InputDecoration(labelText: 'عنوان الاختبار', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _subjectController, decoration: const InputDecoration(labelText: 'المادة', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _dayController, decoration: const InputDecoration(labelText: 'اليوم', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _dateController, decoration: const InputDecoration(labelText: 'التاريخ', border: OutlineInputBorder())),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    if (_questions.isEmpty) {
      return const Center(child: Text('لا توجد أسئلة مضافة. اضغط على زر + لإضافة سؤال ورقي.'));
    }
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _questions.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = _questions.removeAt(oldIndex);
          _questions.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        final q = _questions[index];
        return Card(
          key: ValueKey(q.id),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(q.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('الدرجة: ${q.score}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openQuestionDialog(existingQuestion: q, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => _questions.removeAt(index)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(42),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('تصدير الاختبار كـ PDF / حفظ / طباعة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            onPressed: _exportOrPrintExam,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Table(
                  border: TableBorder.all(color: Colors.transparent),
                  columnWidths: const {
                    0: FlexColumnWidth(1.2),
                    1: FlexColumnWidth(1.8),
                    2: FlexColumnWidth(1.2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_schoolController.text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 1),
                            Text(_timeController.text, style: const TextStyle(fontSize: 10, color: Colors.black)),
                          ],
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 0.8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              _examTitleController.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_subjectController.text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                            Text(_dayController.text, style: const TextStyle(fontSize: 10, color: Colors.black)),
                            Text(_dateController.text, style: const TextStyle(fontSize: 10, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text('اسم الطالب : ________________________________________', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('الشعبة (     )', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ],
                ),
                const Divider(color: Colors.black, thickness: 1.2, height: 10),
                Table(
                  border: TableBorder.all(color: Colors.black, width: 0.8),
                  columnWidths: const {
                    0: FlexColumnWidth(5.5),
                    1: FlexColumnWidth(0.8),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            '* أجب عن جميع الأسئلة الآتية :',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'الدرجة',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_questions.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Center(child: Text('أضف أسئلة لتظهر هنا بتنسيق الورقة الرسمية', style: TextStyle(color: Colors.black))),
                                )
                              else
                                ..._questions.asMap().entries.map((entry) {
                                  return _buildExactQuestionStyle(entry.key + 1, entry.value);
                                }).toList(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _questions.map((q) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 30.0),
                                child: Text('${q.score.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExactQuestionStyle(int number, Question q) {
    const arabicLetters = ['أ', 'ب', 'ج', 'د', 'هـ', 'و'];
    String letter = (number - 1 < arabicLetters.length) ? arabicLetters[number - 1] : '$number';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$letter) ${q.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Colors.black)),
          const SizedBox(height: 4),
          if (q.type == QuestionType.text)
            for (int i = 0; i < q.answerLines; i++)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black, style: BorderStyle.solid, width: 0.7)),
                ),
                height: 18,
              )
          else if (q.type == QuestionType.mcq)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: q.options.map((opt) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text('• $opt', style: const TextStyle(color: Colors.black, fontSize: 11)),
                )).toList(),
              ),
            )
          else if (q.type == QuestionType.trueFalse)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                children: q.statements.map((stmt) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Expanded(child: Text('• $stmt', style: const TextStyle(color: Colors.black, fontSize: 11))),
                        const Text('(   )', style: TextStyle(color: Colors.black, fontSize: 11)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _openQuestionDialog({Question? existingQuestion, int? index}) {
    final isEditing = existingQuestion != null;
    final titleController = TextEditingController(text: isEditing ? existingQuestion.title : '');
    final scoreController = TextEditingController(text: isEditing ? existingQuestion.score.toString() : '6');
    QuestionType selectedType = isEditing ? existingQuestion.type : QuestionType.text;
    int lines = isEditing ? existingQuestion.answerLines : 3;

    List<TextEditingController> optionControllers = isEditing && existingQuestion.options.isNotEmpty
        ? existingQuestion.options.map((o) => TextEditingController(text: o)).toList()
        : [TextEditingController(), TextEditingController()];

    List<TextEditingController> tfControllers = isEditing && existingQuestion.statements.isNotEmpty
        ? existingQuestion.statements.map((s) => TextEditingController(text: s)).toList()
        : [TextEditingController()];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: Text(isEditing ? 'تعديل السؤال' : 'إضافة سؤال جديد'),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<QuestionType>(
                          value: selectedType,
                          decoration: const InputDecoration(labelText: 'نوع السؤال', border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: QuestionType.text, child: Text('سؤال مقالي / فراغات')),
                            DropdownMenuItem(value: QuestionType.mcq, child: Text('اختيار من متعدد')),
                            DropdownMenuItem(value: QuestionType.trueFalse, child: Text('صح أو خطأ')),
                          ],
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedType = val);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(controller: titleController, decoration: const InputDecoration(labelText: 'نص السؤال', border: OutlineInputBorder())),
                        const SizedBox(height: 12),
                        TextField(controller: scoreController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الدرجة', border: OutlineInputBorder())),
                        const SizedBox(height: 16),
                        const Divider(),
                        if (selectedType == QuestionType.text)
                          Row(
                            children: [
                              const Text('عدد أسطر الإجابة: '),
                              DropdownButton<int>(
                                value: lines,
                                items: [1, 2, 3, 4, 5, 6].map((l) => DropdownMenuItem(value: l, child: Text('$l'))).toList(),
                                onChanged: (val) => setDialogState(() => lines = val!),
                              ),
                            ],
                          )
                        else if (selectedType == QuestionType.mcq)
                          ...optionControllers.asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: TextField(controller: e.value, decoration: InputDecoration(labelText: 'الخيار ${e.key + 1}', isDense: true)),
                          ))
                        else if (selectedType == QuestionType.trueFalse)
                          ...tfControllers.asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: TextField(controller: e.value, decoration: InputDecoration(labelText: 'العبارة ${e.key + 1}', isDense: true)),
                          )),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
                  ElevatedButton(
                    onPressed: () {
                      final double score = double.tryParse(scoreController.text) ?? 6.0;
                      final newQuestion = Question(
                        id: isEditing ? existingQuestion.id : DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.isEmpty ? 'سؤال بدون عنوان' : titleController.text,
                        type: selectedType,
                        score: score,
                        answerLines: lines,
                        options: optionControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
                        statements: tfControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
                      );

                      setState(() {
                        if (isEditing && index != null) {
                          _questions[index] = newQuestion;
                        } else {
                          _questions.add(newQuestion);
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text(isEditing ? 'تحديث' : 'حفظ'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
