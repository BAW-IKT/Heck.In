import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RadarChartDialog extends StatefulWidget {
  final Map<String, double> data;
  final Map<String, Color> groupColors;

  RadarChartDialog({
    required this.data,
    required this.groupColors,
  });

  @override
  _RadarChartDialogState createState() => _RadarChartDialogState();
}

class _RadarChartDialogState extends State<RadarChartDialog> {
  double angleValue = 0;

  List<Widget> _buildLegend() {
    return widget.groupColors.entries.map((entry) {
      return Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: entry.value,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5),
          Text(entry.key),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 350,
        width: 350,
        child: Column(
          children: [
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _buildLegend(),
            ),
            SizedBox(height: 10),
            Expanded(
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      fillColor: Colors.blue.withOpacity(0.5),
                      borderColor: Colors.blue,
                      dataEntries: widget.data.values
                          .map((value) => RadarEntry(value: value))
                          .toList(),
                    ),
                  ],
                  getTitle: (index, _) => RadarChartTitle(
                    text: widget.data.keys.elementAt(index),
                    angle: angleValue,
                  ),
                  titleTextStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
