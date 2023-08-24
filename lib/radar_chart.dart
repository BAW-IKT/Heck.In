import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:hedge_profiler_flutter/form_data.dart';

class RadarChartDialog extends StatefulWidget {
  final Map<String, double> data;
  final Map<String, String> dataToGroup;
  final Map<String, Color> groupColors;
  final String currentLocale;
  final GlobalKey repaintBoundaryKey = GlobalKey();
  final void Function(Future<Uint8List> Function())
      setCapturePngFromRadarChartCallback;

  RadarChartDialog({
    Key? key,
    required this.data,
    required this.dataToGroup,
    required this.groupColors,
    required this.currentLocale,
    required this.setCapturePngFromRadarChartCallback,
  }) : super(key: key);

  @override
  RadarChartDialogState createState() => RadarChartDialogState();
}

class RadarChartDialogState extends State<RadarChartDialog> {
  Map<String, String> engTrans = getEnglishRadarPlotTranslations();

  @override
  Widget build(BuildContext context) {
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
              widget.currentLocale == "EN" ? "Result Graph" : "Ergebnisrose",
              style: const TextStyle(
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
            const SizedBox(height: 40),
            Expanded(child: buildRadarChart()),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.setCapturePngFromRadarChartCallback(capturePngFromRadarChart);
  }

  List<Widget> _buildLegend() {
    return widget.groupColors.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              width: 12,
              height: 10,
              decoration: BoxDecoration(
                color: entry.value,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              widget.currentLocale == "EN" ? engTrans[entry.key]! : entry.key,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
                // Add more properties if needed
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget buildRadarChart() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = Theme.of(context).colorScheme.onSecondary;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return RepaintBoundary(
      key: widget.repaintBoundaryKey,
      child: RadarChart(
        RadarChartData(
          tickCount: 5,
          dataSets: buildRadarDataSets(backgroundColor),
          getTitle: (index, count) {
            // calculate rotation
            double rotationAngle = -90 + count;
            if (count > 180) {
              rotationAngle = 90 + count;
            }

            // if text is too long, break it
            String tickText = widget.data.keys.elementAt(index);
            tickText =
                widget.currentLocale == "EN" ? engTrans[tickText]! : tickText;
            if (tickText.contains("&")) {
              var tickSplits = tickText.split("&");
              tickSplits[0] += "&";
              tickText = tickSplits.join("\n");
            }

            return RadarChartTitle(
              text: tickText,
              angle: rotationAngle,
              // positionPercentageOffset: 0.7,
            );
          },
          ticksTextStyle: TextStyle(
              fontSize: 8, color: isDarkMode ? Colors.white70 : Colors.black87),
          titlePositionPercentageOffset: isTablet ? 0.25 : 0.35,
          titleTextStyle: TextStyle(fontSize: isTablet ? 8 : 7),
          radarBackgroundColor: backgroundColor.withOpacity(0.5),
          gridBorderData: const BorderSide(color: Colors.black26, width: 2),
          tickBorderData: const BorderSide(color: Colors.black26, width: 2),
          radarBorderData: const BorderSide(color: Colors.black87, width: 2),
        ),
      ),
    );
  }

  List<RadarDataSet> buildRadarDataSets(Color backgroundColor) {
    List<RadarDataSet> radarDataSets = [];
    const int maxEntries = 13;

    widget.groupColors.forEach((group, color) {
      List<RadarEntry> entries =
          List.filled(maxEntries, const RadarEntry(value: 0));

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
          fillColor: color.withOpacity(0.40),
          borderColor: color,
        ),
      );

      // Create an additional dataset to hide entries with value 0
      List<RadarEntry> hiddenEntries =
          List.filled(maxEntries, const RadarEntry(value: 0));
      radarDataSets.add(
        RadarDataSet(
          dataEntries: hiddenEntries,
          fillColor: backgroundColor,
          borderColor: backgroundColor,
        ),
      );
    });
    return radarDataSets;
  }

  // Future<Uint8List> capturePngFromRadarChart() async {
  //   RenderRepaintBoundary boundary = widget.repaintBoundaryKey.currentContext!
  //       .findRenderObject() as RenderRepaintBoundary;
  //   var image = await boundary.toImage();
  //   var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData!.buffer.asUint8List();
  // }
  Future<Uint8List> capturePngFromRadarChart() async {
    RenderRepaintBoundary boundary = widget.repaintBoundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
