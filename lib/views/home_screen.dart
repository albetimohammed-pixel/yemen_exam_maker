import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'main_editor_screen.dart';
import 'user_guide_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // قائمة تجريبية للاختبارات السابقة
  final List<Map<String, String>> _previousExams = [
    {
      'title': 'اختبار الشهر الأول - الرياضيات',
      'subject': 'الرياضيات',
      'date': '2026/08/25',
    },
    {
      'title': 'اختبار منتصف الفصل - العلوم',
      'subject': 'العلوم العامة',
      'date': '2026/08/28',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('المحرر المدرسي Pro 39'),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
        elevation: 0,
        // زر المعلومات والدليل في الأعلى
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'معلومات التطبيق والدليل',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserGuideScreen()),
              );
            },
          ),
        ],
      ),
      body: _previousExams.isEmpty ? _buildEmptyState() : _buildExamsList(),

      // موقع الزر العائم في أسفل اليمين (في بيئة RTL)
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainEditorScreen()),
          );
        },
        backgroundColor: AppColors.accentGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'إضافة اختبار',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // واجهة فارغة في حال لا توجد اختبارات محفوطة
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.note_add_outlined, size: 80, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'لا توجد اختبارات سابقة',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'اضغط على زر "إضافة اختبار" لإنشاء أول اختبار لك',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // قائمة عرض الاختبارات السابقة
  Widget _buildExamsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _previousExams.length,
      itemBuilder: (context, index) {
        final exam = _previousExams[index];
        return Card(
          color: AppColors.cardDark,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryPurple.withOpacity(0.3),
              child: const Icon(Icons.description, color: AppColors.accentGreen),
            ),
            title: Text(
              exam['title'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'المادة: ${exam['subject']}  •  التاريخ: ${exam['date']}',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.accentGreen),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainEditorScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      _previousExams.removeAt(index);
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
}

