import 'package:flutter/material.dart';
import '../models/exam_paper_model.dart';
import '../widgets/yemeni_exam_header.dart';
import 'about_screen.dart';

class MainEditorScreen extends StatefulWidget {
  const MainEditorScreen({Key? key}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ExamHeaderData _headerData = ExamHeaderData();
  final List<QuestionItem> _questions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('محرر الاختبارات المدرسية'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'عن المطور',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.article), text: 'الكليشة'),
              Tab(icon: Icon(Icons.format_list_bulleted), text: 'الأسئلة'),
              Tab(icon: Icon(Icons.print), text: 'المعاينة والطباعة'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildHeaderEditorTab(),
            _buildQuestionsEditorTab(),
            _buildExamPreviewTab(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. تبويب تعديل الكليشة
  // ---------------------------------------------------------------------------
  Widget _buildHeaderEditorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نمط الكليشة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButtonFormField<HeaderStyle>(
            value: _headerData.style,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: HeaderStyle.republicEmblem, child: Text('الرسمي (شعار الجمهورية)')),
              DropdownMenuItem(value: HeaderStyle.ovalTriple, child: Text('البيضاوي الثلاثي')),
              DropdownMenuItem(value: HeaderStyle.modernMinimal, child: Text('الحديث البسيط')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _headerData.style = val);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _headerData.schoolName,
            decoration: const InputDecoration(labelText: 'اسم المدرسة', border: OutlineInputBorder()),
            onChanged: (val) => _headerData.schoolName = val,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _headerData.subject,
                  decoration: const InputDecoration(labelText: 'المادة', border: OutlineInputBorder()),
                  onChanged: (val) => _headerData.subject = val,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: _headerData.grade,
                  decoration: const InputDecoration(labelText: 'الصف', border: OutlineInputBorder()),
                  onChanged: (val) => _headerData.grade = val,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _headerData.examType,
                  decoration: const InputDecoration(labelText: 'نوع الاختبار', border: OutlineInputBorder()),
                  onChanged: (val) => _headerData.examType = val,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: _headerData.duration,
                  decoration: const InputDecoration(labelText: 'زمن الاختبار', border: OutlineInputBorder()),
                  onChanged: (val) => _headerData.duration = val,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _headerData.academicYear,
            decoration: const InputDecoration(labelText: 'العام الدراسي', border: OutlineInputBorder()),
            onChanged: (val) => _headerData.academicYear = val,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. تبويب إدارة الأسئلة
  // ---------------------------------------------------------------------------
  Widget _buildQuestionsEditorTab() {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openQuestionDialog(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة سؤال جديد'),
      ),
      body: _questions.isEmpty
          ? const Center(
              child: Text(
                'لا توجد أسئلة مضافة بعد.\nاضغط على "إضافة سؤال جديد" للبدء.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    title: Text(
                      q.title.isEmpty ? 'سؤال بدون عنوان' : q.title,
                      style: TextStyle(
                        fontWeight: q.isBold ? FontWeight.bold : FontWeight.normal,
                        fontStyle: q.isItalic ? FontStyle.italic : FontStyle.normal,
                        decoration: q.isUnderline ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text('نوع السؤال: ${_getQuestionTypeName(q.type)} | الدرجة: ${q.score}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.amber),
                          onPressed: () => _openQuestionDialog(existingQuestion: q, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => _questions.removeAt(index));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getQuestionTypeName(QuestionType type) {
    switch (type) {
      case QuestionType.text:
        return 'سؤال نصي';
      case QuestionType.multipleChoice:
        return 'اختر الإجابة الصحيحة';
      case QuestionType.trueFalse:
        return 'صح أو خطأ';
      case QuestionType.table:
        return 'جدول';
    }
  }

  // ---------------------------------------------------------------------------
  // نافذة إضافة وتعديل السؤال الذكية
  // ---------------------------------------------------------------------------
  void _openQuestionDialog({QuestionItem? existingQuestion, int? index}) {
    final isEditing = existingQuestion != null;
    final QuestionItem item = existingQuestion ??
        QuestionItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        );

    final titleController = TextEditingController(text: item.title);
    final scoreController = TextEditingController(text: item.score.toString());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'تعديل السؤال' : 'إضافة سؤال جديد'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اختيار نوع السؤال
                      const Text('نوع السؤال:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<QuestionType>(
                        value: item.type,
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                        items: const [
                          DropdownMenuItem(value: QuestionType.text, child: Text('سؤال نصي')),
                          DropdownMenuItem(value: QuestionType.multipleChoice, child: Text('اختر الإجابة الصحيحة')),
                          DropdownMenuItem(value: QuestionType.trueFalse, child: Text('صح أو خطأ')),
                          DropdownMenuItem(value: QuestionType.table, child: Text('جدول')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => item.type = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // نص السؤال الرئيسي
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'نص السؤال / راس السؤال',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => item.title = val,
                      ),
                      const SizedBox(height: 10),

                      // أدوات التنسيق والدرجة
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: scoreController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'الدرجة',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (val) => item.score = double.tryParse(val) ?? 0.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // شريط أدوات التنسيق
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.format_bold),
                                  color: item.isBold ? Colors.blue : Colors.black,
                                  onPressed: () => setDialogState(() => item.isBold = !item.isBold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.format_italic),
                                  color: item.isItalic ? Colors.blue : Colors.black,
                                  onPressed: () => setDialogState(() => item.isItalic = !item.isItalic),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.format_underlined),
                                  color: item.isUnderline ? Colors.blue : Colors.black,
                                  onPressed: () => setDialogState(() => item.isUnderline = !item.isUnderline),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // الخصائص التفاعلية بناءً على نوع السؤال المختار
                      if (item.type == QuestionType.text) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('عدد أسطر الإجابة:', style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<int>(
                              value: item.answerLines,
                              items: List.generate(10, (i) => i + 1)
                                  .map((n) => DropdownMenuItem(value: n, child: Text('$n أسطر')))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => item.answerLines = val);
                              },
                            ),
                          ],
                        ),
                      ] else if (item.type == QuestionType.multipleChoice) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('خيارات الإجابة:', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextButton.icon(
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('إضافة خيار'),
                              onPressed: () {
                                setDialogState(() {
                                  item.options.add('خيار ${item.options.length + 1}');
                                });
                              },
                            ),
                          ],
                        ),
                        ...item.options.asMap().entries.map((entry) {
                          final idx = entry.key;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: entry.value,
                                    decoration: InputDecoration(
                                      labelText: 'خيار ${idx + 1}',
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    ),
                                    onChanged: (val) => item.options[idx] = val,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    setDialogState(() => item.options.removeAt(idx));
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ] else if (item.type == QuestionType.trueFalse) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('فقرات الصح والخطأ:', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextButton.icon(
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('إضافة فقرة'),
                              onPressed: () {
                                setDialogState(() {
                                  item.statements.add('فقرة ${item.statements.length + 1}');
                                });
                              },
                            ),
                          ],
                        ),
                        ...item.statements.asMap().entries.map((entry) {
                          final idx = entry.key;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: entry.value,
                                    decoration: InputDecoration(
                                      labelText: 'العبارة ${idx + 1}',
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    ),
                                    onChanged: (val) => item.statements[idx] = val,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    setDialogState(() => item.statements.removeAt(idx));
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ] else if (item.type == QuestionType.table) ...[
                        const Text('تنسيق وإعدادات الجدول:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),

                        // أدوات التحكم بالصفوف
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'عدد الصفوف: ${item.tableData.length}',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('إضافة صف', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    setDialogState(() {
                                      final colsCount = item.tableData.isNotEmpty ? item.tableData[0].length : 2;
                                      item.tableData.add(List.filled(colsCount, ''));
                                      item.tableRows = item.tableData.length;
                                    });
                                  },
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                                  tooltip: 'حذف صف',
                                  onPressed: item.tableData.length > 1
                                      ? () {
                                          setDialogState(() {
                                            item.tableData.removeLast();
                                            item.tableRows = item.tableData.length;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // أدوات التحكم بالأعمدة
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'عدد الأعمدة: ${item.tableData.isNotEmpty ? item.tableData[0].length : 0}',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('إضافة عمود', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    setDialogState(() {
                                      for (var row in item.tableData) {
                                        row.add('');
                                      }
                                      if (item.tableData.isEmpty) {
                                        item.tableData.add(['']);
                                      }
                                      item.tableCols = item.tableData[0].length;
                                    });
                                  },
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                                  tooltip: 'حذف عمود',
                                  onPressed: (item.tableData.isNotEmpty && item.tableData[0].length > 1)
                                      ? () {
                                          setDialogState(() {
                                            for (var row in item.tableData) {
                                              if (row.isNotEmpty) row.removeLast();
                                            }
                                            item.tableCols = item.tableData[0].length;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('محتويات الخلايا:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                        const SizedBox(height: 6),

                        // الجدول التفاعلي لإدخال القيم
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            defaultColumnWidth: const FixedColumnWidth(85.0),
                            border: TableBorder.all(color: Colors.black54),
                            children: List.generate(item.tableData.length, (r) {
                              return TableRow(
                                children: List.generate(item.tableData[r].length, (c) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      key: ValueKey('cell_${r}_${c}_${item.tableData[r][c]}'),
                                      initialValue: item.tableData[r][c],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        border: InputBorder.none,
                                        hintText: '...',
                                      ),
                                      onChanged: (val) {
                                        item.tableData[r][c] = val;
                                      },
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
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
                    setState(() {
                      if (isEditing && index != null) {
                        _questions[index] = item;
                      } else {
                        _questions.add(item);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('حفظ السؤال'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 3. تبويب المعاينة المباشرة والطباعة
  // ---------------------------------------------------------------------------
  Widget _buildExamPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // ورقة الاختبار المطبوعة
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1.5),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الكليشة الرسمية
                YemeniExamHeader(headerData: _headerData),
                const SizedBox(height: 12),

                // عرض الأسئلة المضافة
                if (_questions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Text('ورقة الاختبار فارغة حالياً.\nقم بإضافة أسئلة من تبويب "الأسئلة".', textAlign: TextAlign.center),
                    ),
                  )
                else
                  ..._questions.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final q = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildQuestionPreviewItem(idx + 1, q),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPreviewItem(int number, QuestionItem q) {
    final titleTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: q.isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: q.isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: q.isUnderline ? TextDecoration.underline : TextDecoration.none,
      color: Colors.black,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان السؤال والدرجة
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('س $number: ${q.title}', style: titleTextStyle),
            ),
            Text('(${q.score} درجات)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
        const SizedBox(height: 6),

        // طريقة العرض بناءً على النوع
        if (q.type == QuestionType.text) ...[
          // أسطر إجابة فارغة
          Column(
            children: List.generate(
              q.answerLines,
              (index) => Container(
                margin: const EdgeInsets.only(top: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey, style: BorderStyle.solid)),
                ),
              ),
            ),
          ),
        ] else if (q.type == QuestionType.multipleChoice) ...[
          // خيارات الإجابة
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 4.0),
            child: Wrap(
              spacing: 20,
              runSpacing: 8,
              children: q.options.asMap().entries.map((opt) {
                final letters = ['أ', 'ب', 'ج', 'د', 'هـ', 'و'];
                final letter = opt.key < letters.length ? letters[opt.key] : '${opt.key + 1}';
                return Text('$letter) ${opt.value}', style: const TextStyle(fontSize: 12, color: Colors.black));
              }).toList(),
            ),
          ),
        ] else if (q.type == QuestionType.trueFalse) ...[
          // فقرات صح أو خطأ
          Column(
            children: q.statements.asMap().entries.map((st) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${st.key + 1}- ${st.value}', style: const TextStyle(fontSize: 12, color: Colors.black)),
                    const Text('(   )', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              );
            }).toList(),
          ),
        ] else if (q.type == QuestionType.table) ...[
          // جدول الاختبار
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: q.tableData.map((row) {
                return TableRow(
                  children: row.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        cell,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: Colors.black),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
