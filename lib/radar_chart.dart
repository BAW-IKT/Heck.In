import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:hedge_profiler_flutter/colors.dart';
import 'package:hedge_profiler_flutter/form_data.dart';

class RadarChartDialog extends StatefulWidget {
  final Map<String, double> data;
  final Map<String, String> dataToGroup;
  final Map<String, Color> groupColors;
  final String currentLocale;
  final GlobalKey repaintBoundaryKey = GlobalKey();
  final void Function(Future<Uint8List> Function())
      setCapturePngFromRadarChartCallback;
  final bool exportReady;

  RadarChartDialog({
    Key? key,
    required this.data,
    required this.dataToGroup,
    required this.groupColors,
    required this.currentLocale,
    required this.setCapturePngFromRadarChartCallback,
    required this.exportReady,
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

    double? sizedBoxHeight = isTablet ? 500 : 450;
    double? sizedBoxWidth = isTablet ? 800 : 450;

    Color headerColor = MyColors.white;
    Color legendTextColor = Colors.white70;
    if (widget.exportReady) {
      headerColor = MyColors.black;
      legendTextColor = Colors.black87;
      sizedBoxHeight = 400;
      sizedBoxWidth = 600;
    }

    return Dialog(
      child: RepaintBoundary(
        key: widget.repaintBoundaryKey,
        child: SizedBox(
          height: sizedBoxHeight,
          width: sizedBoxWidth,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                widget.currentLocale == "EN" ? "Result Graph" : "Ergebnisrose",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: headerColor,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: _buildLegend(legendTextColor),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(child: buildRadarChart()),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.setCapturePngFromRadarChartCallback(capturePngFromRadarChart);
  }

  List<Widget> _buildLegend(Color legendTextColor) {
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
                color: legendTextColor,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget buildRadarChart() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    Color tickTextColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color backgroundColor = widget.exportReady
        ? MyColors.white
        : Theme.of(context).colorScheme.onSecondary;
    Color gridBorderColor = Colors.black26;
    Color tickBorderColor = Colors.black26;
    Color outerBorderColor = Colors.black87;
    Color middleRoseCenterCenter =
        widget.exportReady ? MyColors.white : backgroundColor;
    Color middleRoseBorderCenter = MyColors.black;

    double? graphWidth = isTablet ? 400 : 230;
    double? graphHeight = isTablet ? 400 : 240;

    if (widget.exportReady) {
      tickTextColor = MyColors.black;
      graphHeight = 800;
      graphWidth = 500;
    }

    return SizedBox(
      width: graphWidth,
      height: graphHeight,
      child: RadarChart(
        RadarChartData(
          tickCount: 5,
          dataSets: buildRadarDataSets(
              middleRoseCenterCenter, middleRoseBorderCenter),
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
              // positionPercentageOffset: 0.1,
            );
          },
          ticksTextStyle: TextStyle(fontSize: 8, color: tickTextColor),
          titlePositionPercentageOffset: isTablet ? 0.25 : 0.33,
          titleTextStyle:
              TextStyle(fontSize: isTablet ? 8 : 7, color: tickTextColor),
          radarBackgroundColor: backgroundColor.withOpacity(0.5),
          gridBorderData: BorderSide(color: gridBorderColor, width: 2),
          tickBorderData: BorderSide(color: tickBorderColor, width: 2),
          radarBorderData: BorderSide(color: outerBorderColor, width: 2),
        ),
      ),
    );
  }

  List<RadarDataSet> buildRadarDataSets(
      Color middleRoseCenterColor, Color middleRoseBorderColor) {
    List<RadarDataSet> radarDataSets = [];
    int maxEntries = getRadarDataGroups().length;

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
    });

    // Create an additional dataset to hide entries with value 0
    List<RadarEntry> hiddenEntries =
        List.filled(maxEntries, const RadarEntry(value: 0));
    radarDataSets.add(
      RadarDataSet(
        dataEntries: hiddenEntries,
        fillColor: middleRoseCenterColor,
        borderColor: middleRoseBorderColor,
        borderWidth: 0,
        entryRadius: 5.3,
      ),
    );
    return radarDataSets;
  }

  Future<Uint8List> capturePngFromRadarChart() async {
    RenderRepaintBoundary boundary = widget.repaintBoundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
