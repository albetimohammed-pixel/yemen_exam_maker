import 'package:flutter/material.dart';
import '../models/exam_paper_model.dart';

class ExamPaperTable extends StatelessWidget {
  final List<QuestionItem> questions;
  final String closingText;

  const ExamPaperTable({
    Key? key,
    required this.questions,
    this.closingText = 'مع تمنياتي لكم بالتوفيق والنجاح',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.2)),
        child: Column(
          children: [
            // ترويسة الجدول
            Container(
              color: Colors.grey.shade200,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
              child: Row(
                children: [
                  const SizedBox(
                    width: 40,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('الرقم', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black)),
                    ),
                  ),
                  _buildDivider(),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                      child: Text('الأسئلة والأستلزام', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5, color: Colors.black)),
                    ),
                  ),
                  _buildDivider(),
                  const SizedBox(
                    width: 45,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('الدرجة', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
            if (questions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    'لا توجد أسئلة مضافة.\nاضغط على (إضافة سؤال جديد) للبدء في كتابة الأسئلة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 9, color: Colors.black54),
                  ),
                ),
              )
            else
              ...questions.map((q) => _buildQuestionRow(q)).toList(),

            if (closingText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black, width: 1))),
                child: Text(
                  closingText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, fontStyle: FontStyle.italic, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionRow(QuestionItem q) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 0.8))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 40,
              child: Center(
                child: Text(q.number, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5, color: Colors.black)),
              ),
            ),
            _buildDivider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: q.fontSize,
                        fontWeight: q.isBold ? FontWeight.bold : FontWeight.normal,
                        fontStyle: q.isItalic ? FontStyle.italic : FontStyle.normal,
                        decoration: q.isUnderline ? TextDecoration.underline : TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),
                    if (q.subItems.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      ...q.subItems.map(
                        (sub) => Padding(
                          padding: const EdgeInsets.only(bottom: 2.0, right: 8.0),
                          child: Text(sub, textAlign: TextAlign.right, style: TextStyle(fontSize: q.fontSize - 1, color: Colors.black)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _buildDivider(),
            SizedBox(
              width: 45,
              child: Center(
                child: Text(
                  q.grade > 0 ? '${q.grade}' : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Container(width: 1, color: Colors.black);
}

