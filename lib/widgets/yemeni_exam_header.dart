import 'package:flutter/material.dart';
import '../models/exam_paper_model.dart';

class YemeniExamHeader extends StatelessWidget {
  final YemeniHeaderModel header;

  const YemeniExamHeader({Key? key, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الكليشة البيضاوية الثلاثية
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: _buildOvalBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildText('المادة : ${header.subject}'),
                    _buildText('اليوم: ${header.day}'),
                    _buildText('التاريخ ${header.date}'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 4,
              child: _buildOvalBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      header.examTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${header.gradeLevel} - ${header.academicYear}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 8, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 3,
              child: _buildOvalBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildText(header.schoolName, bold: true),
                    _buildText(header.directorate),
                    _buildText('الزمن : ${header.duration}'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // شريط اسم الطالب
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 1.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'اسم الطالب : ...........................................................',
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                'الشعبة (    )',
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOvalBox({required Widget child}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildText(String text, {bool bold = false}) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 8, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: Colors.black),
    );
  }
}

