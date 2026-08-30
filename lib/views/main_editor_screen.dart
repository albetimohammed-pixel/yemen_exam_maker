import 'package:flutter/material.dart';

import '../controllers/editor_controller.dart';
import '../core/constants/app_colors.dart';
import '../painters/page_canvas_painter.dart';
import '../widgets/question_bar_widget.dart';
import '../widgets/answer_sheet_grid_builder.dart';
import 'widgets/custom_slider_tile.dart';
import 'widgets/template_picker_sheet.dart';
import 'widgets/preview_toolbar.dart';

class MainEditorScreen extends StatefulWidget {
  const MainEditorScreen({Key? key}) : super(key: key);

  @override
  State<MainEditorScreen> createState() => _MainEditorScreenState();
}

class _MainEditorScreenState extends State<MainEditorScreen> {
  final EditorController _controller = EditorController();
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _openTemplatePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplatePickerSheet(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحرر المدرسي الشامل Pro 39'),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              // 1. منطقة معاينة الورقة المعتمدة على InteractiveViewer (Pinch-to-Zoom)
              Expanded(
                flex: 5,
                child: Container(
                  color: AppColors.canvasBg,
                  width: double.infinity,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.8,
                    maxScale: 3.0,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
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
                                  crossAxisAlignment: CrossAlignment.start,
                                  children: [
                                    QuestionBarWidget(
                                      questionNumber: 'س1',
                                      questionTitle: 'أجب عن الأسئلة التالية بدقة',
                                      gradeText: '10 درجات',
                                      config: _controller.questionConfig,
                                    ),
                                    const SizedBox(height: 12),
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
                ),
              ),

              // 2. شريط الأدوات السريع
              PreviewToolbar(
                onZoomToggle: _resetZoom,
                onTemplateTap: _openTemplatePicker,
                onPrintTap: () {},
              ),

              // 3. لوحة تحكم الخصائص التفاعلية
              Expanded(
                flex: 4,
                child: Container(
                  color: AppColors.backgroundDark,
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          indicatorColor: AppColors.accentGreen,
                          labelColor: AppColors.accentGreen,
                          unselectedLabelColor: Colors.white70,
                          tabs: [
                            Tab(icon: Icon(Icons.settings), text: 'السؤال'),
                            Tab(icon: Icon(Icons.crop_square), text: 'الإطار'),
                            Tab(icon: Icon(Icons.blur_on), text: 'العلامة المائية'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // 1. تبويب السؤال
                              ListView(
                                children: [
                                  CustomSliderTile(
                                    label: 'عرض الشريط',
                                    value: _controller.questionConfig.barWidth,
                                    min: 150,
                                    max: 400,
                                    unit: 'dp',
                                    onChanged: _controller.updateQuestionBarWidth,
                                  ),
                                  CustomSliderTile(
                                    label: 'انحناء الزوايا',
                                    value: _controller.questionConfig.cornerRadius,
                                    min: 0,
                                    max: 20,
                                    unit: 'dp',
                                    onChanged: _controller.updateQuestionCornerRadius,
                                  ),
                                ],
                              ),

                              // 2. تبويب الإطار
                              ListView(
                                children: [
                                  CustomSliderTile(
                                    label: 'سمك الإطار الخارجي',
                                    value: _controller.borderConfig.outerBorderWidth,
                                    min: 1,
                                    max: 10,
                                    unit: 'dp',
                                    onChanged: _controller.updateOuterBorderWidth,
                                  ),
                                  CustomSliderTile(
                                    label: 'المسافة الفاصلة',
                                    value: _controller.borderConfig.spacing,
                                    min: 0,
                                    max: 20,
                                    unit: 'dp',
                                    onChanged: _controller.updateSpacing,
                                  ),
                                ],
                              ),

                              // 3. تبويب العلامة المائية
                              ListView(
                                children: [
                                  CustomSliderTile(
                                    label: 'درجة الشفافية',
                                    value: _controller.watermarkConfig.opacity * 100,
                                    min: 0,
                                    max: 30,
                                    unit: '%',
                                    onChanged: (v) => _controller.updateWatermarkOpacity(v / 100),
                                  ),
                                  CustomSliderTile(
                                    label: 'زاوية الدوران',
                                    value: _controller.watermarkConfig.rotationDegree,
                                    min: 0,
                                    max: 360,
                                    unit: '°',
                                    onChanged: _controller.updateWatermarkRotation,
                                  ),
                                ],
                              ),
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
}
