import 'package:flutter/material.dart';

import '../controllers/editor_controller.dart';
import '../core/constants/app_colors.dart';
import '../models/exam_model.dart';
import '../painters/page_canvas_painter.dart';
import '../widgets/exam_header_widget.dart';
import '../widgets/exam_table_widget.dart';
import '../widgets/question_bar_widget.dart';
import '../widgets/answer_sheet_grid_builder.dart';
import 'widgets/custom_slider_tile.dart';

class MainEditorScreen extends StatefulWidget {
  const MainEditorScreen({Key? key}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> {
  final EditorController _controller = EditorController();
  final ExamHeaderData _headerData = ExamHeaderData();
  final ExamTableData _tableData = ExamTableData();
  final ExamFooterData _footerData = ExamFooterData();

  // خيارات تنسيق النص الحالي
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صانع الاختبارات الاحترافي'),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {},
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              // 1. ورقة المعاينة الحية (A4 Canvas)
              Expanded(
                flex: 5,
                child: Container(
                  color: AppColors.canvasBg,
                  width: double.infinity,
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
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // الكليشة العلوية
                                    ExamHeaderWidget(headerData: _headerData),
                                    const SizedBox(height: 10),

                                    // شريط السؤال الأول
                                    QuestionBarWidget(
                                      questionNumber: 'س1',
                                      questionTitle: 'أجب عن الأسئلة التالية بدقة',
                                      gradeText: '10 درجات',
                                      config: _controller.questionConfig,
                                    ),
                                    const SizedBox(height: 8),

                                    // شبكة الإجابات
                                    AnswerSheetGridBuilder(
                                      tfCount: _controller.tfQuestionCount,
                                      mcqCount: _controller.mcqQuestionCount,
                                      language: _controller.selectedLanguage,
                                    ),
                                    const SizedBox(height: 10),

                                    // جدول التوصيل / المقارنة المعاين
                                    ExamTableWidget(tableData: _tableData),
                                    const SizedBox(height: 20),

                                    // تذييل الصفحة الختامي
                                    _buildFooterPreview(),
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

              // 2. لوحة التبديل والتحكم السفلي
              Expanded(
                flex: 4,
                child: Container(
                  color: AppColors.backgroundDark,
                  child: DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        const TabBar(
                          indicatorColor: AppColors.accentGreen,
                          labelColor: AppColors.accentGreen,
                          unselectedLabelColor: Colors.white70,
                          isScrollable: true,
                          tabs: [
                            Tab(icon: Icon(Icons.subtitles), text: 'الكليشة'),
                            Tab(icon: Icon(Icons.format_bold), text: 'التنسيق والأسئلة'),
                            Tab(icon: Icon(Icons.table_chart), text: 'الجداول'),
                            Tab(icon: Icon(Icons.tune), text: 'الإطار والعلامة'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildHeaderTab(),
                              _buildFormattingTab(),
                              _buildTableTab(),
                              _buildDesignTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // معاينة الختام وتوقيع المعلم
  Widget _buildFooterPreview() {
    return Column(
      children: [
        const Divider(color: Colors.black54),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _footerData.wishText,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            Text(
              _footerData.teacherSignature,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  // 1. تبويب تعديل الكليشة
  Widget _buildHeaderTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildInputField('اسم المدرسة', _headerData.schoolName, (v) {
          setState(() => _headerData.schoolName = v);
        }),
        _buildInputField('المادة', _headerData.subject, (v) {
          setState(() => _headerData.subject = v);
        }),
        _buildInputField('الصف', _headerData.grade, (v) {
          setState(() => _headerData.grade = v);
        }),
        _buildInputField('اسم المعلم', _headerData.teacherName, (v) {
          setState(() => _headerData.teacherName = v);
        }),
        SwitchListTile(
          title: const Text('إظهار البسملة', style: TextStyle(color: Colors.white)),
          value: _headerData.showBasmala,
          onChanged: (v) => setState(() => _headerData.showBasmala = v),
        ),
      ],
    );
  }

  // 2. تبويب التنسيق (Bold, Italic, Underline) والأسئلة
  Widget _buildFormattingTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'أدوات تنسيق النص:',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.format_bold, color: _isBold ? AppColors.accentGreen : Colors.white),
              onPressed: () => setState(() => _isBold = !_isBold),
            ),
            IconButton(
              icon: Icon(Icons.format_italic, color: _isItalic ? AppColors.accentGreen : Colors.white),
              onPressed: () => setState(() => _isItalic = !_isItalic),
            ),
            IconButton(
              icon: Icon(Icons.format_underlined, color: _isUnderline ? AppColors.accentGreen : Colors.white),
              onPressed: () => setState(() => _isUnderline = !_isUnderline),
            ),
          ],
        ),
        const Divider(color: Colors.white24),
        _buildInputField('عبارة الختام', _footerData.wishText, (v) {
          setState(() => _footerData.wishText = v);
        }),
      ],
    );
  }

  // 3. تبويب الجداول
  Widget _buildTableTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _tableData.headers = ['العمود (أ)', 'العمود (ب)'];
              _tableData.cells = [
                ['1. السؤال الأول', 'أ. الإجابة الأولى'],
                ['2. السؤال الثاني', 'ب. الإجابة الثانية'],
              ];
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('إدراج جدول توصيل نموذجي'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
        ),
      ],
    );
  }

  // 4. تبويب الإطار والعلامة
  Widget _buildDesignTab() {
    return ListView(
      children: [
        CustomSliderTile(
          label: 'عرض شريط السؤال',
          value: _controller.questionConfig.barWidth,
          min: 150,
          max: 400,
          unit: 'dp',
          onChanged: _controller.updateQuestionBarWidth,
        ),
        CustomSliderTile(
          label: 'سمك الإطار الخارجي',
          value: _controller.borderConfig.outerBorderWidth,
          min: 1,
          max: 10,
          unit: 'dp',
          onChanged: _controller.updateOuterBorderWidth,
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String initialValue, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        initialValue: initialValue,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: AppColors.cardDark,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
