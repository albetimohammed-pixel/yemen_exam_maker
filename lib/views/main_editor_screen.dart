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

  // خيارات السؤال النصي
  int answerLines;

  // خيارات اختيار من متعدد
  List<String> options;

  // خيارات صح أو خطأ
  List<String> statements;

  // خيارات الجدول التفاعلي
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

  // controllers الكليشة (الهيدر)
  final _schoolController = TextEditingController(text: 'مدرسة النهضة الإعدادية');
  final _subjectController = TextEditingController(text: 'العلوم العامة');
  final _gradeController = TextEditingController(text: 'الصف التاسع');
  final _examTypeController = TextEditingController(text: 'اختبار نهاية الفصل الدراسي الأول');

  // قائمة الأسئلة
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
    _subjectController.dispose();
    _gradeController.dispose();
    _examTypeController.dispose();
    super.dispose();
  }

  // دالة تصدير وطباعة الاختبار (PDF / Print)
  void _exportOrPrintExam() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري تجهيز الاختبار للطباعة والتصدير كـ PDF...'),
        duration: Duration(seconds: 2),
      ),
    );
    // هنا يتم ربط مكتبة الطباعة أو حفظ الـ PDF مستقبلاً بكل سهولة
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('محرر الاختبارات'),
          centerTitle: true,
          actions: [
            // زر الطباعة والتصدير الدائم في أعلى الشاشة
            IconButton(
              icon: const Icon(Icons.print, color: Colors.white),
              tooltip: 'طباعة / تصدير PDF',
              onPressed: _exportOrPrintExam,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.description), text: 'الكليشة'),
              Tab(icon: Icon(Icons.list_alt), text: 'الأسئلة'),
              Tab(icon: Icon(Icons.print), text: 'المعاينة والطباعة'),
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
                label: const Text('إضافة سؤال'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // التبويب الأول: الكليشة (بيانات الهيدر)
  // --------------------------------------------------------------------------
  Widget _buildHeaderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('بيانات كليشة الاختبار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _schoolController,
            decoration: const InputDecoration(labelText: 'اسم المدرسة', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(labelText: 'المادة الدراسية', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _gradeController,
            decoration: const InputDecoration(labelText: 'الصف / المرحلة', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _examTypeController,
            decoration: const InputDecoration(labelText: 'نوع الاختبار', border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // التبويب الثاني: إدارة الأسئلة
  // --------------------------------------------------------------------------
  Widget _buildQuestionsTab() {
    if (_questions.isEmpty) {
      return const Center(
        child: Text('لا توجد أسئلة مضافة حتى الآن. اضغط على زر + لإضافة سؤال.'),
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
            subtitle: Text('النوع: ${_getTypeName(q.type)} | الدرجة: ${q.score}'),
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
  // التبويب الثالث: المعاينة والطباعة
  // --------------------------------------------------------------------------
  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // زر بارز إضافي في تبويب المعاينة للتصدير الواضح
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('تصدير الاختبار كـ PDF / طباعة نهائية', style: TextStyle(fontSize: 16)),
            onPressed: _exportOrPrintExam,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_schoolController.text, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('المادة: ${_subjectController.text}'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(_examTypeController.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('الصف: ${_gradeController.text}'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('الزمن: ساعة واحدة'),
                        Text('الدرجة الكلية: ______'),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 2, height: 30),

                if (_questions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text('ورقة الاختبار فارغة حالياً.')),
                  )
                else
                  ..._questions.asMap().entries.map((entry) {
                    return _buildQuestionPreviewItem(entry.key + 1, entry.value);
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPreviewItem(int number, Question q) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('س$number: ${q.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Text('(${q.score} درجات)', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),

          if (q.type == QuestionType.text) ...[
            for (int i = 0; i < q.answerLines; i++)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey, style: BorderStyle.solid)),
                ),
                height: 22,
              )
          ]
          else if (q.type == QuestionType.mcq) ...[
            Wrap(
              spacing: 20,
              runSpacing: 8,
              children: q.options.map((opt) => Text('⚪ $opt')).toList(),
            )
          ]
          else if (q.type == QuestionType.trueFalse) ...[
            Column(
              children: q.statements.map((stmt) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('• $stmt')),
                      const Text('(   )'),
                    ],
                  ),
                );
              }).toList(),
            )
          ]
          else if (q.type == QuestionType.table) ...[
            Table(
              border: TableBorder.all(color: Colors.black54),
              children: List.generate(q.rows, (rIdx) {
                return TableRow(
                  children: List.generate(q.cols, (cIdx) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
            )
          ],
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // نافذة إضافة وتعديل الأسئلة المتقدمة (_openQuestionDialog)
  // --------------------------------------------------------------------------
  void _openQuestionDialog({Question? existingQuestion, int? index}) {
    final isEditing = existingQuestion != null;

    final titleController = TextEditingController(text: isEditing ? existingQuestion.title : '');
    final scoreController = TextEditingController(text: isEditing ? existingQuestion.score.toString() : '1.0');
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
                title: Text(isEditing ? 'تعديل سؤال' : 'إضافة سؤال جديد'),
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
                            DropdownMenuItem(value: QuestionType.text, child: Text('سؤال نصي / مقالي')),
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
                          decoration: const InputDecoration(labelText: 'نص السؤال الرئيسي', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: scoreController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'الدرجة', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),

                        if (selectedType == QuestionType.text) ...[
                          Row(
                            children: [
                              const Text('عدد أسطر الإجابة: '),
                              DropdownButton<int>(
                                value: lines,
                                items: [1, 2, 3, 4, 5, 6, 8].map((l) {
                                  return DropdownMenuItem(value: l, child: Text('$l أسطر'));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setDialogState(() => lines = val);
                                },
                              ),
                            ],
                          )
                        ] else if (selectedType == QuestionType.mcq) ...[
                          const Text('خيارات الإجابة:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          const Text('العبارات والفقرات:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          const Text('محتوى خلايا الجدول:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      final double score = double.tryParse(scoreController.text) ?? 1.0;
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

  String _getTypeName(QuestionType type) {
    switch (type) {
      case QuestionType.text:
        return 'نصي / مقالي';
      case QuestionType.mcq:
        return 'اختيار من متعدد';
      case QuestionType.trueFalse:
        return 'صح أو خطأ';
      case QuestionType.table:
        return 'جدول تفاعلي';
    }
  }
}
