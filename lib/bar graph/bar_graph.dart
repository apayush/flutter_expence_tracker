import 'package:expence_tracker/bar%20graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  const MyBarGraph({
    super.key,
    required this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thurAmount,
    required this.friAmount,
    required this.satAmount,
    });

  @override
  Widget build(BuildContext context) {

    //initialize the bar data 
    BarData myBarData = BarData(
        sunAmount: sunAmount, 
        monAmount: monAmount, 
        tueAmount: tueAmount, 
        wedAmount: wedAmount, 
        thurAmount: thurAmount, 
        friAmount: friAmount, 
        satAmount: satAmount);

        myBarData.initializeBarData();
    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: GetBottomTitles,
            )
          )
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: myBarData.barData
          .map((data) => BarChartGroupData(x: data.x,
          barRods: [
            BarChartRodData(
              toY: data.y,
              color: Color.fromARGB(255, 122, 169, 193),
              width: 25,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: Colors.grey[200],
              ),
              ),
          ])
          )
          .toList(),
      )
    );
  }
}

Widget GetBottomTitles(double value, TitleMeta meta) {
  const Style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('SUN',style: Style,);
      break;
    case 1:
      text = const Text('MON',style: Style,);
      break;
    case 2:
      text = const Text('TUE',style: Style,);
      break;
    case 3:
      text = const Text('WED',style: Style,);
      break;
    case 4:
      text = const Text('THUR',style: Style,);
      break;
    case 5:
      text = const Text('FRI',style: Style,);
      break;
    case 6:
      text = const Text('SAT',style: Style,);
      break;
    default:
      text = const Text('',style: Style,);
      break;
  }
  return SideTitleWidget(
    child: text, 
    axisSide: meta.axisSide,
    );
}