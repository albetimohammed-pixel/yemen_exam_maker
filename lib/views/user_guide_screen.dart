import 'package:flutter/material.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الاستخدام'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // تم التصحيح هنا
          children: const [
            Text(
              'طريقة استخدام صانع الاختبارات:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('1. من الشاشة الرئيسية، اضغط على زر (+ إنشاء اختبار جديد).'),
            SizedBox(height: 8),
            Text('2. قم بتعديل بيانات الكليشة (اسم المدرسة، المادة، الصف، الزمن...).'),
            SizedBox(height: 8),
            Text('3. انتقل لتبويب (التنسيق والأسئلة) لإضافة الأسئلة وتخصيص الخطوط والدرجات.'),
            SizedBox(height: 8),
            Text('4. احفظ الاختبار للرجوع إليه سابقاً أو طباعته بسهولة.'),
          ],
        ),
      ),
    );
  }
}
