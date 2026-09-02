import 'package:flutter/material.dart';
import '../models/exam_paper_model.dart';

class YemeniExamHeader extends StatelessWidget {
  final ExamHeaderData headerData;

  const YemeniExamHeader({Key? key, required this.headerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 0.0),
            child: _buildHeaderContent(),
          ),
          // شريط اسم الطالب والشعبة المطبق في الصورة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.black, width: 1.2),
                right: BorderSide(color: Colors.black, width: 1.2),
                bottom: BorderSide(color: Colors.black, width: 1.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'اسم الطالب : .....................................................',
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Text(
                  'الشعبة (  ${headerData.section}  )',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    switch (headerData.style) {
      case HeaderStyle.ovalTriple:
        return _buildOvalStyle();
      case HeaderStyle.modernMinimal:
        return _buildModernStyle();
      case HeaderStyle.republicEmblem:
      default:
        return _buildEmblemStyle();
    }
  }

  // 1. نمط الشعار البيضاوي المطابق للورقة والصورة
  Widget _buildOvalStyle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Row(
        children: [
          // القسم الأيمن
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Colors.black, width: 1.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(headerData.schoolName, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('مديرية : ${headerData.directorate}', style: const TextStyle(fontSize: 9, color: Colors.black)),
                  Text('الزمن : ${headerData.duration}', style: const TextStyle(fontSize: 9, color: Colors.black)),
                ],
              ),
            ),
          ),
          // القسم الأوسط البيضاوي
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.2),
                      borderRadius: const BorderRadius.all(Radius.elliptical(120, 35)),
                    ),
                    child: Text(
                      headerData.examType,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${headerData.grade} - للعام ${headerData.academicYear}',
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          // القسم الأيسر
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black, width: 1.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('المادة : ${headerData.subject}', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('اليوم : ${headerData.day}', style: const TextStyle(fontSize: 9, color: Colors.black)),
                  Text('التاريخ : ${headerData.date}', style: const TextStyle(fontSize: 9, color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. نمط شعار الجمهورية
  Widget _buildEmblemStyle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(headerData.republic, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.black)),
                Text(headerData.ministry, style: const TextStyle(fontSize: 8, color: Colors.black)),
                Text(headerData.directorate, style: const TextStyle(fontSize: 8, color: Colors.black)),
                Text('مدرسة: ${headerData.schoolName}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (headerData.showEmblem) ...[
                  CustomPaint(
                    size: const Size(28, 20),
                    painter: YemenEmblemPainter(),
                  ),
                  const SizedBox(height: 2),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    headerData.examType,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 2),
                Text('العام الدراسي: ${headerData.academicYear}', style: const TextStyle(fontSize: 7.5, color: Colors.black)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('المادة: ${headerData.subject}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('الصف: ${headerData.grade}', style: const TextStyle(fontSize: 8.5, color: Colors.black)),
                Text('التاريخ: ${headerData.date}', style: const TextStyle(fontSize: 8, color: Colors.black)),
                Text('الزمن: ${headerData.duration}', style: const TextStyle(fontSize: 8, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. النمط الحديث المبسط
  Widget _buildModernStyle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${headerData.republic} - ${headerData.schoolName}', style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.black)),
              Text('${headerData.examType} - ${headerData.academicYear}', style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
          const Divider(color: Colors.black, height: 4, thickness: 0.8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المادة: ${headerData.subject}', style: const TextStyle(fontSize: 8, color: Colors.black)),
              Text('الصف: ${headerData.grade}', style: const TextStyle(fontSize: 8, color: Colors.black)),
              Text('الزمن: ${headerData.duration}', style: const TextStyle(fontSize: 8, color: Colors.black)),
              Text('التاريخ: ${headerData.date}', style: const TextStyle(fontSize: 8, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}

class YemenEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width * 0.2, size.height * 0.4);
    path.lineTo(0, size.height * 0.3);
    path.lineTo(size.width * 0.15, size.height * 0.7);
    path.lineTo(size.width * 0.35, size.height * 0.65);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(size.width * 0.65, size.height * 0.65);
    path.lineTo(size.width * 0.85, size.height * 0.7);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
