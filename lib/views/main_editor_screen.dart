import 'package:flutter/material.dart';
import '../controllers/editor_controller.dart';
import '../core/constants/app_colors.dart';
import '../models/exam_paper_model.dart';
import '../painters/page_canvas_painter.dart';
import '../widgets/yemeni_exam_header.dart';
import '../widgets/exam_paper_table.dart';

class MainEditorScreen extends StatefulWidget {
  const MainEditorScreen({Key? key}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> {
  final EditorController _controller = EditorController();
  final YemeniHeaderModel _headerData = YemeniHeaderModel();
  final List<QuestionItem> _questionsList = [];

  final TextEditingController _qTitleController = TextEditingController();
  final TextEditingController _qGradeController = TextEditingController();
  final TextEditingController _qNumberController = TextEditingController();
  bool _isBold = false;
  bool _isUnderline = false;

  @override
  void dispose() {
    _controller.dispose();
    _qTitleController.dispose();
    _qGradeController.dispose();
    _qNumberController.dispose();
    super.dispose();
  }

  void _addNewQuestion() {
    if (_qTitleController.text.trim().isEmpty) return;

    setState(() {
      _questionsList.add(
        QuestionItem(
          id: DateTime.now().toString(),
          number: _qNumberController.text.isEmpty ? '${_questionsList.length + 1}' : _qNumberController.text,
          title: _qTitleController.text,
          grade: int.tryParse(_qGradeController.text) ?? 0,
          isBold: _isBold,
          isUnderline: _isUnderline,
        ),
      );
    });

    _qTitleController.clear();
    _qGradeController.clear();
    _qNumberController.clear();
    Navigator.pop(context);
  }

  void _openAddQuestionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardDark,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافة سؤال جديد إلى الاختبار',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _qNumberController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'رقم السؤال (مثلاً 1 أو أ)',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _qGradeController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'الدرجة',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _qTitleController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'نص السؤال',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                FilterChip(
                  label: const Text('خط عريض B'),
                  selected: _isBold,
                  onSelected: (v) => setState(() => _isBold = v),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('خط سفلي U'),
                  selected: _isUnderline,
                  onSelected: (v) => setState(() => _isUnderline = v),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addNewQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('حفظ وإضافة للورقة', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محرر الورقة الامتحانية'),
        backgroundColor: AppColors.darkPurple,
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              // ورقة معاينة A4 الرسمية
              Expanded(
                child: Container(
                  color: AppColors.canvasBg,
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 3.0,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        child: AspectRatio(
                          aspectRatio: 1 / 1.414,
                          child: CustomPaint(
                            painter: PageCanvasPainter(
                              borderConfig: _controller.borderConfig,
                              watermarkConfig: _controller.watermarkConfig,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    YemeniExamHeader(header: _headerData),
                                    const SizedBox(height: 8),
                                    ExamPaperTable(questions: _questionsList),
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
              ),

              // شريط زر الإضافة أسفل الشاشة
              Container(
                color: AppColors.backgroundDark,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _openAddQuestionDialog,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('إضافة سؤال جديد'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGreen,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _questionsList.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
