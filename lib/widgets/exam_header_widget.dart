import 'package:flutter/material.dart';
import '../models/exam_model.dart';

class ExamHeaderWidget extends StatelessWidget {
  final ExamHeaderData headerData;

  const ExamHeaderWidget({Key? key, required this.headerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
      ),
      child: Column(
        children: [
          // 1. البسملة في أعلى المنتصف
          if (headerData.showBasmala)
            const Padding(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Text(
                'بسم الله الرحمن الرحيم',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),

          // 2. توزيع الأعمدة الثلاثة للكليشة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العمود الأيمن: البيانات الرسمية للمدرسة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headerData.country, style: _headerStyle),
                    Text(headerData.ministry, style: _headerStyle),
                    Text(headerData.directorate, style: _headerStyle),
                    Text(headerData.schoolName, style: _headerStyle),
                  ],
                ),
              ),

              // العمود الأوسط: عنوان الاختبار والمرحلة
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        headerData.semester,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'مادة: ${headerData.subject}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // العمود الأيسر: الصف، الزمن، والمعلم
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('الصف: ${headerData.grade}', style: _headerStyle),
                    Text('الزمن: ${headerData.examTime}', style: _headerStyle),
                    Text('المعلم: ${headerData.teacherName}', style: _headerStyle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
}

