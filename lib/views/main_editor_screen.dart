import 'package:flutter/material.dart';

import '../controllers/editor_controller.dart';
import '../painters/page_canvas_painter.dart';
import '../widgets/question_bar_widget.dart';
import '../widgets/answer_sheet_grid_builder.dart';

class MainEditorScreen extends StatefulWidget {
  const MainEditorScreen({Key? key}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> {
  final EditorController _controller = EditorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحرر المدرسي الشامل Pro 39'),
        centerTitle: true,
        backgroundColor: const Color(0xFF673AB7),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // مسار استدعاء محرك الطباعة والتصدير
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              // 1. منطقة المعاينة المباشرة (Paper Canvas Preview Area)
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1 / 1.414, // نسبة أبعاد ورقة A4
                      child: CustomPaint(
                        painter: PageCanvasPainter(
                          borderConfig: _controller.borderConfig,
                          watermarkConfig: _controller.watermarkConfig,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAlignment.start,
                              children: [
                                // عينة من شريط الأسئلة المعاين
                                QuestionBarWidget(
                                  questionNumber: 'س1',
                                  questionTitle: 'ضع علامة (صح) أو (خطأ) أمام العبارات التالية',
                                  gradeText: '5 درجات',
                                  config: _controller.questionConfig,
                                ),
                                const SizedBox(height: 16),
                                // عينة شبكة صفحة الإجابات
                                AnswerSheetGridBuilder(
                                  tfCount: _controller.tfQuestionCount,
                                  mcqCount: _controller.mcqQuestionCount,
                                  language: _controller.selectedLanguage,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. لوحة التحكم والضبط السفلي (Control Panel Tabs)
              Expanded(
                flex: 4,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Color(0xFF673AB7),
                        unselectedLabelColor: Colors.black54,
                        tabs: [
                          Tab(icon: Icon(Icons.edit_note), text: 'السؤال'),
                          Tab(icon: Icon(Icons.crop_square), text: 'الإطار'),
                          Tab(icon: Icon(Icons.branding_watermark), text: 'العلامة المائية'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // تبويب إعدادات شريط السؤال
                            _buildQuestionControls(),
                            // تبويب إعدادات الإطار والحدود
                            _buildBorderControls(),
                            // تبويب إعدادات العلامة المائية
                            _buildWatermarkControls(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // عناصر التحكم بشريط السؤال
  Widget _buildQuestionControls() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SwitchListTile(
          title: const Text('إظهار مربع الدرجة'),
          value: _controller.questionConfig.showGradeBox,
          onChanged: _controller.toggleShowGradeBox,
        ),
        SwitchListTile(
          title: const Text('إظهار الشريط الجانبي'),
          value: _controller.questionConfig.showSidebar,
          onChanged: _controller.toggleShowSidebar,
        ),
        Text('انحناء الزوايا: ${_controller.questionConfig.cornerRadius.toStringAsFixed(1)} dp'),
        Slider(
          value: _controller.questionConfig.cornerRadius,
          min: 0,
          max: 20,
          onChanged: _controller.updateQuestionCornerRadius,
        ),
      ],
    );
  }

  // عناصر التحكم بالإطار والحدود
  Widget _buildBorderControls() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SwitchListTile(
          title: const Text('تفعيل إطار الصفحة'),
          value: _controller.borderConfig.isEnabled,
          onChanged: _controller.toggleBorder,
        ),
        Text('سمك الإطار الخارجي: ${_controller.borderConfig.outerBorderWidth.toStringAsFixed(1)} dp'),
        Slider(
          value: _controller.borderConfig.outerBorderWidth,
          min: 1,
          max: 10,
          onChanged: _controller.updateOuterBorderWidth,
        ),
        Text('المسافة الفاصلة: ${_controller.borderConfig.spacing.toStringAsFixed(1)} dp'),
        Slider(
          value: _controller.borderConfig.spacing,
          min: 0,
          max: 15,
          onChanged: _controller.updateSpacing,
        ),
      ],
    );
  }

  // عناصر التحكم بالعلامة المائية
  Widget _buildWatermarkControls() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SwitchListTile(
          title: const Text('تفعيل العلامة المائية'),
          value: _controller.watermarkConfig.isEnabled,
          onChanged: _controller.toggleWatermark,
        ),
        Text('درجة الشفافية: ${(_controller.watermarkConfig.opacity * 100).toInt()}%'),
        Slider(
          value: _controller.watermarkConfig.opacity,
          min: 0.0,
          max: 0.3,
          onChanged: _controller.updateWatermarkOpacity,
        ),
        Text('زاوية الدوران: ${_controller.watermarkConfig.rotationDegree.toInt()}°'),
        Slider(
          value: _controller.watermarkConfig.rotationDegree,
          min: 0,
          max: 360,
          onChanged: _controller.updateWatermarkRotation,
        ),
      ],
    );
  }
}
