import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RadarChartDialog extends StatefulWidget {
  final Map<String, double> data;
  final Map<String, String> dataToGroup;
  final Map<String, Color> groupColors;

  const RadarChartDialog({
    Key? key,
    required this.data,
    required this.dataToGroup,
    required this.groupColors,
  }) : super(key: key);

  @override
  _RadarChartDialogState createState() => _RadarChartDialogState();
}

class _RadarChartDialogState extends State<RadarChartDialog> {

  List<Widget> _buildLegend() {
    return widget.groupColors.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: entry.value,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(entry.key),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const int maxEntries = 13;

    List<RadarDataSet> radarDataSets = [];

    widget.groupColors.forEach((group, color) {
      List<RadarEntry> entries = List.filled(maxEntries, const RadarEntry(value: 0));

      int index = 0;
      widget.data.forEach((key, value) {
        if (widget.dataToGroup[key] == group) {
          entries[index] = RadarEntry(value: value);
        }
        index++;
      });

      radarDataSets.add(
        RadarDataSet(
          dataEntries: entries,
          fillColor: color.withOpacity(0.33),
          borderColor: color,
        ),
      );

      // Create an additional dataset to hide entries with value 0
      List<RadarEntry> hiddenEntries = List.filled(maxEntries, const RadarEntry(value: 0));
      radarDataSets.add(
        RadarDataSet(
          dataEntries: hiddenEntries,
          fillColor: Colors.black,
          borderColor: Colors.black,
        ),
      );
    });

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Dialog(
      child: SizedBox(
        height: isTablet ? 500 : 350,
        width: isTablet ? 800 : 350,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Ergebnisrose',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _buildLegend(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RadarChart(
                RadarChartData(
                  tickCount: 5,
                  dataSets: radarDataSets,
                  getTitle: (index, count) {
                    // calculate rotation
                    double rotationAngle = -90 + count;
                    if (count > 180) {
                      rotationAngle = 90 + count;
                    }

                    // if text is too long, break it
                    String tickText = widget.data.keys.elementAt(index);
                    if (tickText.contains("&")) {
                      var tickSplits = tickText.split("&");
                      tickSplits[0] += "&";
                      tickText = tickSplits.join("\n");
                    }

                    return RadarChartTitle(
                      text: tickText,
                      angle: rotationAngle,
                    );
                  },
                  // ticksTextStyle: TextStyle(textBaseline: ), // TODO: align text left somehow
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
