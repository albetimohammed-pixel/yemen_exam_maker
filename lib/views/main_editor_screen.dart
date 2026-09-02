import 'package:flutter/material.dart';

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

  // controllers كليشة الاختبار المطابقة للصورة تماماً
  final _schoolController = TextEditingController(text: 'ثانوية المكلا النموذجية للبنين\nمديرية المكلا');
  final _timeController = TextEditingController(text: 'الزمن : حصة');
  final _examTitleController = TextEditingController(text: 'اختبار الشهري الثاني الفصل الدراسي الثاني\nللصف الأول الثانوي - للعام 2025-2026م');
  final _subjectController = TextEditingController(text: 'المادة : المجتمع');
  final _dayController = TextEditingController(text: 'اليوم : الاثنين');
  final _dateController = TextEditingController(text: 'التاريخ : 2026/4/20م');
  final _studentNameController = TextEditingController();
  final _classSectionController = TextEditingController();

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
    _studentNameController.dispose();
    _classSectionController.dispose();
    super.dispose();
  }

  void _exportOrPrintExam() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري تصدير ورقة الاختبار بالمطابقة الرسمية...'),
        duration: Duration(seconds: 2),
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
              tooltip: 'طباعة / تصدير PDF',
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
          TextField(
            controller: _schoolController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'بيانات المدرسة (اليمين)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _timeController,
            decoration: const InputDecoration(labelText: 'الزمن (تحت المدرسة)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _examTitleController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'عنوان الاختبار (المنتصف)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(labelText: 'المادة (اليسار)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dayController,
            decoration: const InputDecoration(labelText: 'اليوم (اليسار)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'التاريخ (اليسار)', border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    if (_questions.isEmpty) {
      return const Center(
        child: Text('لا توجد أسئلة مضافة. اضغط على زر + لإضافة سؤال ورقي.'),
      );
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
                  onPressed: () {
                    setState(() {
                      _questions.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // تبويب المعاينة المطابق 100% لتصميم الصورة الرسمية
  // --------------------------------------------------------------------------
  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('تصدير الاختبار كـ PDF / طباعة مطابقة للصورة', style: TextStyle(fontSize: 16)),
            onPressed: _exportOrPrintExam,
          ),
          const SizedBox(height: 12),
          // إطار ورقة الاختبار الخارجية المماثلة للصورة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ترويسة الاختبار المطابقة للصورة تماماً
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
                        // اليمين: المدرسة والزمن
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_schoolController.text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(_timeController.text, style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                        // المنتصف: العنوان الإطاري
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _examTitleController.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // اليسار: المادة، اليوم، التاريخ
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_subjectController.text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            Text(_dayController.text, style: const TextStyle(fontSize: 11)),
                            Text(_dateController.text, style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // سطر اسم الطالب والشعبة
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text('اسم الطالب : ________________________________________', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('الشعبة (     )', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Divider(color: Colors.black, thickness: 1.5, height: 16),

                // جدول الأسئلة الرئيسي (عمود السؤال وعمود الدرجة)
                Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  columnWidths: const {
                    0: FlexColumnWidth(5.5),
                    1: FlexColumnWidth(0.8),
                  },
                  children: [
                    // صف العنوان الإرشادي داخل الجدول
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            '* أجب عن جميع الأسئلة الآتية :',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            'الدرجة',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    // صف محتوى الأسئلة
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_questions.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Center(child: Text('أضف أسئلة لتظهر هنا بتنسيق الورقة الرسمية')),
                                )
                              else
                                ..._questions.asMap().entries.map((entry) {
                                  return _buildExactQuestionStyle(entry.key + 1, entry.value);
                                }).toList(),
                            ],
                          ),
                        ),
                        // عمود الدرجات الجانبي المماثل للصورة
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _questions.map((q) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 35.0),
                                child: Text('${q.score.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
    // تحويل الرقم إلى الحروف العربية مثل الصورة (أ، ب، ج، د)
    const arabicLetters = ['أ', 'ب', 'ج', 'د', 'هـ', 'و'];
    String letter = (number - 1 < arabicLetters.length) ? arabicLetters[number - 1] : '$number';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$letter) ${q.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),

          if (q.type == QuestionType.text) ...[
            for (int i = 0; i < q.answerLines; i++)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black54, style: BorderStyle.solid, width: 0.8)),
                ),
                height: 20,
              )
          ]
          else if (q.type == QuestionType.mcq) ...[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: q.options.map((opt) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Text('• $opt'),
                )).toList(),
              ),
            )
          ]
          else if (q.type == QuestionType.trueFalse) ...[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                children: q.statements.map((stmt) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      children: [
                        Expanded(child: Text('• $stmt')),
                        const Text('(   )'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ]
          else if (q.type == QuestionType.table) ...[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Table(
                border: TableBorder.all(color: Colors.black54),
                children: List.generate(q.rows, (rIdx) {
                  return TableRow(
                    children: List.generate(q.cols, (cIdx) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          q.tableData.length > rIdx && q.tableData[rIdx].length > cIdx
                              ? q.tableData[rIdx][cIdx]
                              : '',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                  );
                }),
              ),
            )
          ],
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

    int rows = isEditing ? existingQuestion.rows : 2;
    int cols = isEditing ? existingQuestion.cols : 2;
    List<List<TextEditingController>> tableControllers = isEditing
        ? List.generate(rows, (r) => List.generate(cols, (c) => TextEditingController(
            text: (r < existingQuestion.tableData.length && c < existingQuestion.tableData[r].length)
                ? existingQuestion.tableData[r][c]
                : '')))
        : List.generate(rows, (r) => List.generate(cols, (c) => TextEditingController()));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: Text(isEditing ? 'تعديل السؤال الورقي' : 'إضافة سؤال ورقي جديد'),
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
                            DropdownMenuItem(value: QuestionType.table, child: Text('جدول تفاعلي')),
                          ],
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedType = val);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'نص الفقرة أو السؤال', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: scoreController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'الدرجة المخصصة في العمود الجانبي', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),

                        if (selectedType == QuestionType.text) ...[
                          Row(
                            children: [
                              const Text('عدد أسطر الفراغات: '),
                              DropdownButton<int>(
                                value: lines,
                                items: [1, 2, 3, 4, 5, 6].map((l) {
                                  return DropdownMenuItem(value: l, child: Text('$l أسطر'));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setDialogState(() => lines = val);
                                },
                              ),
                            ],
                          )
                        ] else if (selectedType == QuestionType.mcq) ...[
                          const Text('الخيارات:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...optionControllers.asMap().entries.map((e) {
                            final i = e.key;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: e.value,
                                      decoration: InputDecoration(labelText: 'الخيار ${i + 1}', isDense: true),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      if (optionControllers.length > 2) {
                                        setDialogState(() => optionControllers.removeAt(i));
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                          TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة خيار'),
                            onPressed: () {
                              setDialogState(() => optionControllers.add(TextEditingController()));
                            },
                          ),
                        ] else if (selectedType == QuestionType.trueFalse) ...[
                          const Text('العبارات:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...tfControllers.asMap().entries.map((e) {
                            final i = e.key;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: e.value,
                                      decoration: InputDecoration(labelText: 'العبارة ${i + 1}', isDense: true),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      if (tfControllers.length > 1) {
                                        setDialogState(() => tfControllers.removeAt(i));
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                          TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة عبارة'),
                            onPressed: () {
                              setDialogState(() => tfControllers.add(TextEditingController()));
                            },
                          ),
                        ] else if (selectedType == QuestionType.table) ...[
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: rows,
                                  decoration: const InputDecoration(labelText: 'الصفوف'),
                                  items: [1, 2, 3, 4, 5].map((r) => DropdownMenuItem(value: r, child: Text('$r'))).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        rows = val;
                                        tableControllers = List.generate(rows, (r) => List.generate(cols, (c) => TextEditingController()));
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: cols,
                                  decoration: const InputDecoration(labelText: 'الأعمدة'),
                                  items: [1, 2, 3, 4].map((c) => DropdownMenuItem(value: c, child: Text('$c'))).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        cols = val;
                                        tableControllers = List.generate(rows, (r) => List.generate(cols, (c) => TextEditingController()));
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text('محتوى الخلايا:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          for (int r = 0; r < rows; r++)
                            Row(
                              children: [
                                for (int c = 0; c < cols; c++)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: TextField(
                                        controller: tableControllers[r][c],
                                        decoration: InputDecoration(
                                          hintText: 'س$r,ع$c',
                                          border: const OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
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
                        rows: rows,
                        cols: cols,
                        tableData: List.generate(rows, (r) => List.generate(cols, (c) => tableControllers[r][c].text)),
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
