import 'package:flutter/material.dart';
import '../models/exam_paper_model.dart';
import 'main_editor_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final savedExams = ExamStorage.savedExams;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('صانع الاختبارات اليمنية 🇾🇪'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_pin),
              tooltip: 'عن المطور',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainEditorScreen()),
            );
            setState(() {});
          },
          icon: const Icon(Icons.add),
          label: const Text('إنشاء اختبار جديد'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الاختبارات المحفوظة:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: savedExams.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.assignment_outlined, size: 70, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text(
                              'لا توجد اختبارات محفوظة حالياً.\nاضغط على "إنشاء اختبار جديد" للبدء.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: savedExams.length,
                        itemBuilder: (context, index) {
                          final exam = savedExams[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 2,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Icon(Icons.description, color: Colors.white),
                              ),
                              title: Text(
                                exam.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'تاريخ الحفظ: ${exam.dateSaved.year}/${exam.dateSaved.month}/${exam.dateSaved.day} | ${exam.headerData.schoolName}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainEditorScreen(initialExam: exam),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        ExamStorage.deleteExam(exam.id);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainEditorScreen(initialExam: exam),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
