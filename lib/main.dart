import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/main_editor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المحرر المدرسي الشامل Pro 39',
      debugShowCheckedModeBanner: false,
      // تفعيل الثيم الداكن الاحترافي الجديد
      theme: AppTheme.darkEditorTheme, 
      // توجيه التطبيق لشاشتنا الرئيسية المحدثة مع دعم الاتجاه العربي
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: MainEditorScreen(),
      ),
    );
  }
}
