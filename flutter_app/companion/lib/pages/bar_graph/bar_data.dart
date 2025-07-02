import 'package:companion/pages/bar_graph/individual_bar.dart';

class BarData {
  final double monStats;
  final double tueStats;
  final double wedStats;
  final double thuStats;
  final double friStats;
  final double satStats;
  final double sunStats;

  BarData(
      {required this.monStats,
      required this.tueStats,
      required this.wedStats,
      required this.thuStats,
      required this.friStats,
      required this.satStats,
      required this.sunStats});

  List<IndividualBar> barData = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 20, y: monStats),
      IndividualBar(x: 21, y: tueStats),
      IndividualBar(x: 22, y: wedStats),
      IndividualBar(x: 23, y: thuStats),
      IndividualBar(x: 24, y: friStats),
      IndividualBar(x: 25, y: satStats),
      IndividualBar(x: 26, y: sunStats),
    ];
  }
}
