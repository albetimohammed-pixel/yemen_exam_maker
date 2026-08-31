import 'package:flutter/material.dart';
import '../models/exam_paper_model.dart';

class YemeniExamHeader extends StatelessWidget {
  final ExamHeaderData headerData;

  const YemeniExamHeader({Key? key, required this.headerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: const EdgeInsets.bottom(6.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: _buildHeaderContent(),
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

  Widget _buildEmblemStyle() {
    return Row(
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
              Text('الصف: ${headerData.grade} (${headerData.section})', style: const TextStyle(fontSize: 8.5, color: Colors.black)),
              Text('التاريخ: ${headerData.date}', style: const TextStyle(fontSize: 8, color: Colors.black)),
              Text('الزمن: ${headerData.duration}', style: const TextStyle(fontSize: 8, color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOvalStyle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(headerData.republic, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black)),
              Text('مدرسة: ${headerData.schoolName}', style: const TextStyle(fontSize: 8.5, color: Colors.black)),
              Text('المادة: ${headerData.subject}', style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
          Column(
            children: [
              Text(headerData.examType, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
              Text('الصف: ${headerData.grade}', style: const TextStyle(fontSize: 8, color: Colors.black)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('التاريخ: ${headerData.date}', style: const TextStyle(fontSize: 8, color: Colors.black)),
              Text('الزمن: ${headerData.duration}', style: const TextStyle(fontSize: 8, color: Colors.black)),
              Text('الشعبة: ${headerData.section}', style: const TextStyle(fontSize: 8, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernStyle() {
    return Column(
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
            Text('الصف: ${headerData.grade} (${headerData.section})', style: const TextStyle(fontSize: 8, color: Colors.black)),
            Text('الزمن: ${headerData.duration}', style: const TextStyle(fontSize: 8, color: Colors.black)),
            Text('التاريخ: ${headerData.date}', style: const TextStyle(fontSize: 8, color: Colors.black)),
          ],
        ),
      ],
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
