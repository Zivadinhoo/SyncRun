import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TssBarChart extends StatelessWidget {
  final List<double> tssValues;

  const TssBarChart({super.key, required this.tssValues});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  return Text(days[value.toInt()]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              tssValues
                  .asMap()
                  .entries
                  .map(
                    (e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          color: Colors.orange,
                          width: 16,
                          borderRadius:
                              BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
