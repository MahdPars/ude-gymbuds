import 'dart:math';

import 'package:companion/pages/bar_graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {
  double yValue = 0;
  final List weeklySummary;
  BarGraph({super.key, required this.weeklySummary, required this.yValue});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        monStats: weeklySummary[0],
        tueStats: weeklySummary[1],
        wedStats: weeklySummary[2],
        thuStats: weeklySummary[3],
        friStats: weeklySummary[4],
        satStats: weeklySummary[5],
        sunStats: weeklySummary[6]);

    myBarData.initializeBarData();
    double maxValue = yValue;

    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false))),
        maxY: maxValue,
        minY: 0,
        gridData: FlGridData(show: false),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                        toY: min(data.y, maxValue),
                        color: Colors.grey[200],
                        width: 20,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                            show: true, toY: yValue, color: Colors.grey[600])),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
