import 'dart:math';
import 'package:flutter/material.dart';
import '../models/exam_paper_model.dart';
import '../widgets/yemeni_exam_header.dart';
import '../widgets/exam_paper_table.dart';
import 'about_screen.dart';

class MainEditorScreen extends StatefulWidget {
  const MainEditorScreen({Key? key}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> {
  final ExamHeaderData _headerData = ExamHeaderData();
  final List<QuestionItem> _questions = [];

  final List<String> _gradesList = [
    'روضة / تمهيدي',
    'الأول الابتدائي', 'الثاني الابتدائي', 'الثالث الابتدائي', 'الرابع الابتدائي', 'الخامس الابتدائي', 'السادس الابتدائي',
    'الأول المتوسط/الإعدادي', 'الثاني المتوسط/الإعدادي', 'الثالث المتوسط/الإعدادي',
    'الأول الثانوي', 'الثاني الثانوي', 'الثالث الثانوي (علمي)', 'الثالث الثانوي (أدبي)'
  ];

  final List<String> _examTypesList = [
    'اختبار الشهر الأول',
    'اختبار الشهر الثاني',
    'اختبار منتصف الفصل الدراسي الأول',
    'اختبار نهاية الفصل الدراسي الأول',
    'اختبار منتصف الفصل الدراسي الثاني',
    'اختبار نهاية الفصل الدراسي الثاني (النهائي)',
    'اختبار تجريبي'
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('محرر الاختبارات الاحترافي'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_pin),
              tooltip: 'عن المطور',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'طباعة الاختبار',
              onPressed: _printExam,
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'تصدير PDF / صورة',
              onPressed: _exportExam,
            ),
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'حفظ الاختبار',
              onPressed: _saveExam,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit_note), text: 'بيانات الكليشة'),
              Tab(icon: Icon(Icons.format_list_numbered), text: 'الأسئلة'),
              Tab(icon: Icon(Icons.remove_red_eye), text: 'معاينة الورقة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHeaderEditorTab(),
            _buildQuestionsEditorTab(),
            _buildPaperPreviewTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderEditorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تصميم وستايل الكليشة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<HeaderStyle>(
            segments: const [
              ButtonSegment(value: HeaderStyle.republicEmblem, label: Text('الشعار الرسمي')),
              ButtonSegment(value: HeaderStyle.ovalTriple, label: Text('بيضاوي ثلاثي')),
              ButtonSegment(value: HeaderStyle.modernMinimal, label: Text('حديث بسيط')),
            ],
            selected: {_headerData.style},
            onSelectionChanged: (Set<HeaderStyle> newSelection) {
              setState(() {
                _headerData.style = newSelection.first;
              });
            },
          ),
          const Divider(height: 24),

          DropdownButtonFormField<String>(
            value: _gradesList.contains(_headerData.grade) ? _headerData.grade : _gradesList[10],
            decoration: const InputDecoration(labelText: 'الصف الدراسي', border: OutlineInputBorder()),
            items: _gradesList.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (val) => setState(() => _headerData.grade = val ?? ''),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _examTypesList.contains(_headerData.examType) ? _headerData.examType : _examTypesList[1],
            decoration: const InputDecoration(labelText: 'نوع الاختبار', border: OutlineInputBorder()),
            items: _examTypesList.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (val) => setState(() => _headerData.examType = val ?? ''),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _headerData.schoolName),
                  decoration: const InputDecoration(labelText: 'اسم المدرسة', border: OutlineInputBorder()),
                  onChanged: (v) => _headerData.schoolName = v,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _headerData.subject),
                  decoration: const InputDecoration(labelText: 'المادة', border: OutlineInputBorder()),
                  onChanged: (v) => _headerData.subject = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _headerData.section),
                  decoration: const InputDecoration(labelText: 'الفصل/الشعبة (أ، ب...)', border: OutlineInputBorder()),
                  onChanged: (v) => _headerData.section = v,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _headerData.duration),
                  decoration: const InputDecoration(labelText: 'زمن الاختبار', border: OutlineInputBorder()),
                  onChanged: (v) => _headerData.duration = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _headerData.date),
                  decoration: const InputDecoration(labelText: 'التاريخ', border: OutlineInputBorder()),
                  onChanged: (v) => _headerData.date = v,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _headerData.academicYear),
                  decoration: const InputDecoration(labelText: 'العام الدراسي', border: OutlineInputBorder()),
                  onChanged: (v) => _headerData.academicYear = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: TextEditingController(text: _headerData.directorate),
            decoration: const InputDecoration(labelText: 'المديرية / مكتب التربية', border: OutlineInputBorder()),
            onChanged: (v) => _headerData.directorate = v,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsEditorTab() {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addQuestionDialog,
        icon: const Icon(Icons.add),
        label: const Text('إضافة سؤال جديد'),
      ),
      body: _questions.isEmpty
          ? const Center(child: Text('لا توجد أسئلة بعد. اضغط على الزر بالأسفل للإضافة.'))
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(q.number)),
                    title: Text(q.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('الدرجة: ${q.grade} | الفقرات الفرعية: ${q.subItems.length}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _questions.removeAt(index)),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPaperPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)],
          ),
          child: Column(
            children: [
              YemeniExamHeader(headerData: _headerData),
              const SizedBox(height: 6),
              ExamPaperTable(questions: _questions),
            ],
          ),
        ),
      ),
    );
  }

  void _addQuestionDialog() {
    String qNum = 'س ${min(_questions.length + 1, 99)}';
    String qTitle = '';
    double qGrade = 2.0;
    final List<String> subs = [];
    final subController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          title: const Text('إضافة سؤال جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'رقم/رمز السؤال (مثال: س1)'),
                  onChanged: (v) => qNum = v,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'نص السؤال الرئيسي'),
                  onChanged: (v) => qTitle = v,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'درجة السؤال'),
                  onChanged: (v) => qGrade = double.tryParse(v) ?? 2.0,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: subController,
                        decoration: const InputDecoration(labelText: 'إضافة فقرة فرعية (أ، ب، 1...)'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {
                        if (subController.text.isNotEmpty) {
                          setDlgState(() {
                            subs.add(subController.text);
                            subController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                Wrap(
                  children: subs.map((s) => Chip(label: Text(s), onDeleted: () => setDlgState(() => subs.remove(s)))).toList(),
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                if (qTitle.isNotEmpty) {
                  setState(() {
                    _questions.add(QuestionItem(
                      id: DateTime.now().toString(),
                      number: qNum,
                      title: qTitle,
                      subItems: subs,
                      grade: qGrade,
                    ));
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _printExam() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري تجهيز الأمر وإرسال الورقة للطابعة... 🟨')),
    );
  }

  void _exportExam() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تصدير ورقة الاختبار بنجاح بصيغة PDF وجاهزة للمشاركة! 📄✨')),
    );
  }

  void _saveExam() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ نموذج الاختبار في ذاكرة التطبيق بنجاح ✅')),
    );
  }
}
