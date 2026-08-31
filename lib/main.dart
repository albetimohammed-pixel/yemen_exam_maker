import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المحرر المدرسي Pro 39',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkEditorTheme,
      // التوجيه المباشر للشاشة الرئيسية (HomeScreen)
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}
