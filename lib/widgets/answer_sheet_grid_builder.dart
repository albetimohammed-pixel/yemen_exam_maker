import 'package:flutter/material.dart';

class AnswerSheetGridBuilder extends StatelessWidget {
  final int tfCount;
  final int mcqCount;
  final String language; // 'AR' أو 'EN'

  const AnswerSheetGridBuilder({
    Key? key,
    required this.tfCount,
    required this.mcqCount,
    this.language = 'AR',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isArabic = language == 'AR';
    final List<String> mcqOptions = isArabic ? ['أ', 'ب', 'ج', 'د'] : ['A', 'B', 'C', 'D'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tfCount > 0) ...[
          Text(
            isArabic ? 'أسئلة الصواب والخطأ:' : 'True/False Questions:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
            ),
            itemCount: tfCount,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text('${index + 1}. '),
                  const Icon(Icons.check_box_outline_blank, size: 18),
                  Text(isArabic ? ' صح ' : ' T '),
                  const Icon(Icons.check_box_outline_blank, size: 18),
                  Text(isArabic ? ' خطأ' : ' F'),
                ],
              );
            },
          ),
        ],
        if (mcqCount > 0) ...[
          const SizedBox(height: 16),
          Text(
            isArabic ? 'أسئلة الاختيار من متعدد:' : 'Multiple Choice Questions:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mcqCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    SizedBox(width: 30, child: Text('${index + 1}.')),
                    ...mcqOptions.map((opt) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black54),
                                ),
                                child: Center(
                                  child: Text(
                                    opt,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
