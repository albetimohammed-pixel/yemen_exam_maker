import 'package:flutter/material.dart';
import '../models/exam_model.dart';

class ExamTableWidget extends StatelessWidget {
  final ExamTableData tableData;

  const ExamTableWidget({Key? key, required this.tableData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 1),
        children: [
          // رؤوس الجدول
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            children: tableData.headers
                .map(
                  (h) => Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      h,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          // خلايا الجدول
          ...tableData.cells.map(
            (row) => TableRow(
              children: row
                  .map(
                    (cell) => Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        cell.isEmpty ? ' ' : cell,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10.5),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

