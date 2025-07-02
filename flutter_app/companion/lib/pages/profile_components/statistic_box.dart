// ignore_for_file: must_be_immutable

import 'package:companion/pages/bar_graph/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticBox extends StatelessWidget {
  String movedWeight = '';
  String time = '';
  List<double> monthlySum;

  StatisticBox(
      {super.key,
      required this.movedWeight,
      required this.time,
      required this.monthlySum});

  @override
  Widget build(BuildContext context) {
    double fontSize15 =
        (MediaQuery.of(context).size.width * 0.0364).round().toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        height:
            (MediaQuery.of(context).size.height * 0.1482).round().toDouble(),
        width: (MediaQuery.of(context).size.width * 0.7615).round().toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[800],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'moved weight\n',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: fontSize15),
                      ),
                      TextSpan(
                        text: movedWeight,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: fontSize15),
                      ),
                    ],
                  )),
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'time\n',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: fontSize15),
                      ),
                      TextSpan(
                        text: time,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: fontSize15),
                      ),
                    ],
                  )),
                  // Text('1h 46min')
                ],
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height * 0.1186)
                  .round()
                  .toDouble(),
              width: (MediaQuery.of(context).size.width * 0.4136)
                  .round()
                  .toDouble(),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: BarGraph(
                    weeklySummary: monthlySum,
                    yValue: 31,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
