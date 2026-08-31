import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/exam_paper_model.dart';
import 'main_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<SavedExamModel> _savedExams = [];

  void _createNewExam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainEditorScreen(
          onSaveExam: (exam) {
            setState(() {
              _savedExams.add(exam);
            });
          },
        ),
      ),
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
        elevation: 0,
        leading: const Icon(Icons.print),
      ),
      body: _savedExams.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.assignment_outlined, size: 80, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد اختبارات محفوظة',
                    style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اضغط على زر (+ إنشاء اختبار جديد) بالأسفل للبدء',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedExams.length,
              itemBuilder: (context, index) {
                final exam = _savedExams[index];
                return Card(
                  color: AppColors.cardDark,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.accentGreen,
                      child: Icon(Icons.description, color: Colors.white),
                    ),
                    title: Text(
                      '${exam.header.subject} - ${exam.header.examTitle}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'المدرسة: ${exam.header.schoolName} | التاريخ: ${exam.date}',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _savedExams.removeAt(index);
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainEditorScreen(initialExam: exam),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewExam,
        backgroundColor: AppColors.accentGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'إنشاء اختبار جديد',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
