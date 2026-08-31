import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/exam_paper_model.dart';
import '../widgets/yemeni_exam_header.dart';
import '../widgets/exam_paper_table.dart';

class MainEditorScreen extends StatefulWidget {
  final SavedExamModel? initialExam;
  final Function(SavedExamModel)? onSaveExam;

  const MainEditorScreen({Key? key, this.initialExam, this.onSaveExam}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> {
  int _selectedTabIndex = 1; // 0: الكليشة, 1: التنسيق والأسئلة, 2: الجداول, 3: الإطار والعلامة

  late YemeniHeaderModel _headerData;
  List<QuestionItem> _questions = [];
  String _closingText = 'مع تمنياتي لكم بالتوفيق والنجاح';

  bool _globalBold = false;
  bool _globalItalic = false;
  bool _globalUnderline = false;

  late TextEditingController _schoolController;
  late TextEditingController _subjectController;
  late TextEditingController _gradeLevelController;
  late TextEditingController _teacherController;
  late TextEditingController _closingController;

  @override
  void initState() {
    super.initState();
    if (widget.initialExam != null) {
      _headerData = widget.initialExam!.header;
      _questions = List.from(widget.initialExam!.questions);
    } else {
      _headerData = YemeniHeaderModel();
      _questions = [];
    }

    _schoolController = TextEditingController(text: _headerData.schoolName);
    _subjectController = TextEditingController(text: _headerData.subject);
    _gradeLevelController = TextEditingController(text: _headerData.gradeLevel);
    _teacherController = TextEditingController(text: _headerData.teacherName);
    _closingController = TextEditingController(text: _closingText);
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _subjectController.dispose();
    _gradeLevelController.dispose();
    _teacherController.dispose();
    _closingController.dispose();
    super.dispose();
  }

  void _saveExam() {
    final exam = SavedExamModel(
      id: DateTime.now().toString(),
      title: '${_headerData.subject} - ${_headerData.examTitle}',
      date: _headerData.date,
      header: _headerData,
      questions: _questions,
    );
    if (widget.onSaveExam != null) {
      widget.onSaveExam!(exam);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الاختبار بنجاح!')),
    );
  }

  void _openAddQuestionDialog({QuestionItem? editItem, int? editIndex}) {
    final titleCtrl = TextEditingController(text: editItem?.title ?? '');
    final numberCtrl = TextEditingController(text: editItem?.number ?? 'س${_questions.length + 1}');
    final gradeCtrl = TextEditingController(text: editItem != null ? '${editItem.grade}' : '10');
    final subItemsCtrl = TextEditingController(text: editItem?.subItems.join('\n') ?? '');

    bool isBold = editItem?.isBold ?? _globalBold;
    bool isItalic = editItem?.isItalic ?? _globalItalic;
    bool isUnderline = editItem?.isUnderline ?? _globalUnderline;
    double fontSize = editItem?.fontSize ?? 12.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16, right: 16, top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      editItem != null ? 'تعديل السؤال' : 'إضافة سؤال جديد للاختبار',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: numberCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'رقم السؤال (مثال: س1 أو أ)', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: gradeCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'الدرجة', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: titleCtrl,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'نص السؤال الرئيسي',
                        hintText: 'مثال: أ) أكمل الفراغات الآتية بالكلمات المناسبة:',
                        labelStyle: TextStyle(color: Colors.white70),
                        hintStyle: TextStyle(color: Colors.white30),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: subItemsCtrl,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'الفقرات / الأسئلة الفرعية (كل فقرة في سطر)',
                        hintText: '1- يتحقق العدل من خلال...\n2- الشعب بدورة يجعل...',
                        labelStyle: TextStyle(color: Colors.white70),
                        hintStyle: TextStyle(color: Colors.white30),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.format_bold, color: isBold ? AppColors.accentGreen : Colors.white60),
                          onPressed: () => setModalState(() => isBold = !isBold),
                        ),
                        IconButton(
                          icon: Icon(Icons.format_italic, color: isItalic ? AppColors.accentGreen : Colors.white60),
                          onPressed: () => setModalState(() => isItalic = !isItalic),
                        ),
                        IconButton(
                          icon: Icon(Icons.format_underlined, color: isUnderline ? AppColors.accentGreen : Colors.white60),
                          onPressed: () => setModalState(() => isUnderline = !isUnderline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) return;
                        final subList = subItemsCtrl.text.split('\n').where((line) => line.trim().isNotEmpty).toList();
                        final newItem = QuestionItem(
                          id: editItem?.id ?? DateTime.now().toString(),
                          number: numberCtrl.text,
                          title: titleCtrl.text,
                          subItems: subList,
                          grade: int.tryParse(gradeCtrl.text) ?? 0,
                          isBold: isBold,
                          isItalic: isItalic,
                          isUnderline: isUnderline,
                          fontSize: fontSize,
                        );
                        setState(() {
                          if (editIndex != null) {
                            _questions[editIndex] = newItem;
                          } else {
                            _questions.add(newItem);
                          }
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen, minimumSize: const Size(double.infinity, 45)),
                      child: Text(editItem != null ? 'تحديث السؤال' : 'حفظ وإضافة للورقة', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('صانع الاختبارات الاحترافي'),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
        actions: [
          IconButton(icon: const Icon(Icons.save), tooltip: 'حفظ الاختبار', onPressed: _saveExam),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.canvasBg,
              child: InteractiveViewer(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: AspectRatio(
                      aspectRatio: 1 / 1.414,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              YemeniExamHeader(header: _headerData),
                              const SizedBox(height: 8),
                              ExamPaperTable(questions: _questions, closingText: _closingText),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildBottomControlPanel(),
        ],
      ),
    );
  }

  Widget _buildBottomControlPanel() {
    return Container(
      color: AppColors.cardDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedTabIndex == 1) _buildFormattingAndQuestionsTab(),
          if (_selectedTabIndex == 0) _buildHeaderEditTab(),
          if (_selectedTabIndex == 2) _buildTablesTab(),
          if (_selectedTabIndex == 3) _buildBorderTab(),
          const Divider(height: 1, color: Colors.white12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(icon: Icons.subtitles, label: 'الكليشة', index: 0),
              _buildTabItem(icon: Icons.text_fields, label: 'التنسيق والأسئلة', index: 1),
              _buildTabItem(icon: Icons.table_chart, label: 'الجداول', index: 2),
              _buildTabItem(icon: Icons.border_style, label: 'الإطار والعلامة', index: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required IconData icon, required String label, required int index}) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          border: isSelected ? const Border(top: BorderSide(color: AppColors.accentGreen, width: 3)) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.accentGreen : Colors.white60),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: isSelected ? AppColors.accentGreen : Colors.white60, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattingAndQuestionsTab() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text('أدوات تنسيق النص: ', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const Spacer(),
              _buildFormatIconButton('B', _globalBold, () => setState(() => _globalBold = !_globalBold)),
              const SizedBox(width: 8),
              _buildFormatIconButton('I', _globalItalic, () => setState(() => _globalItalic = !_globalItalic)),
              const SizedBox(width: 8),
              _buildFormatIconButton('U', _globalUnderline, () => setState(() => _globalUnderline = !_globalUnderline)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _openAddQuestionDialog(),
            icon: const Icon(Icons.add_circle, color: Colors.white),
            label: const Text('إضافة سؤال جديد للورقة', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen, minimumSize: const Size(double.infinity, 42)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _closingController,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: const InputDecoration(labelText: 'عبارة الختام', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder(), isDense: true),
            onChanged: (val) => setState(() => _closingText = val),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatIconButton(String symbol, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentGreen : Colors.transparent,
          border: Border.all(color: isActive ? AppColors.accentGreen : Colors.white38),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
              decoration: symbol == 'U' ? TextDecoration.underline : TextDecoration.none,
              fontStyle: symbol == 'I' ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderEditTab() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _schoolController,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(labelText: 'اسم المدرسة', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder(), isDense: true),
                  onChanged: (v) => setState(() => _headerData.schoolName = v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _subjectController,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(labelText: 'المادة', labelStyle: TextStyle(color: Colors.white70), border: OutlineInputBorder(), isDense: true),
                  onChanged: (v) => setState(() => _headerData.subject = v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTablesTab() => const Padding(padding: EdgeInsets.all(12.0), child: Text('جدول الأسئلة الورقي الرسمي مفعل تلقائياً', style: TextStyle(color: Colors.white70)));
  Widget _buildBorderTab() => const Padding(padding: EdgeInsets.all(12.0), child: Text('إطار ورقة الاختبار الرسمية مفعل تلقائياً', style: TextStyle(color: Colors.white70)));
}
