import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن المطور والمشروع'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // صورة المطور بتنسيق JPG
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                ],
              ),
              child: const CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/images/developer.jpg'),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'المهندس / مطور التطبيق',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'مطور تطبيقات Flutter ومهندس أنظمة',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'عن تطبيق صانع الاختبارات',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'تطبيق متكامل مخصص للمعلمين لإنشاء وتنسيق أوراق الاختبارات الكليشة والجداول وطباعتها بسهولة ودقة عالية.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.code, color: Colors.indigo),
                    title: const Text('مستودع المشروع على GitHub'),
                    subtitle: const Text('yemen_exam_maker'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.redAccent),
                    title: const Text('التواصل والتعاون الفني'),
                    subtitle: const Text('راسل المطور للاقتراحات والتطوير'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.verified, color: Colors.green),
                    title: Text('إصدار التطبيق'),
                    subtitle: Text('v1.0.0 (الإصدار الرسمي الأول)'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Text(
              'صُنع بكل 💡 وشغف بواسطة المطور',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

