// ignore_for_file: must_be_immutable

import 'package:companion/pages/bar_graph/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StatisticItems extends StatelessWidget {
  String exerciseName = "";
  String maxWeight = "";
  String lastUsedWeight = "";
  List weightsList = [];
  String tendency = "";
  StatisticItems(
      {super.key,
      required this.maxWeight,
      required this.exerciseName,
      required this.lastUsedWeight,
      required this.weightsList,
      required this.tendency});

  @override
  Widget build(BuildContext context) {
    IconData _getTendencyIcon(String tendency) {
      switch (tendency) {
        case "You're getting stronger":
          return Icons.arrow_upward;
        case "You're getting weaker":
          return Icons.arrow_downward;
        case "You're stagnating":
          return Icons.horizontal_rule;
        default:
          return Icons.help_outline;
      }
    }

    Color _getTendencyColor(String tendency) {
      switch (tendency) {
        case "You're getting stronger":
          return Colors.green;
        case "You're getting weaker":
          return Colors.red;
        case "You're stagnating":
          return Colors.blue;
        default:
          return Colors.black;
      }
    }

    final statController = PageController();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  alignment: Alignment.centerLeft,
                  // padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Text(exerciseName,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your last used weights",
                      style: GoogleFonts.inter(
                          fontSize: 16, color: Colors.white.withOpacity(0.4)),
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: BarGraph(
                          weeklySummary: weightsList,
                          yValue: 200,
                        ),
                      ),
                    )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your progression",
                      style: GoogleFonts.inter(
                          fontSize: 16, color: Colors.white.withOpacity(0.4)),
                    )),
              ),
              Expanded(
                child: Stack(children: [
                  PageView(
                    controller: statController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                  child: Text(tendency,
                                      style: GoogleFonts.inter(
                                          fontSize: 25, color: Colors.white))),
                              Center(
                                  child: Icon(_getTendencyIcon(tendency),
                                      size: 60,
                                      color: _getTendencyColor(tendency)
                                          .withOpacity(0.5)))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Your personal best lift: ",
                                        style: GoogleFonts.raleway(
                                            // fontWeight: FontWeight.w400,
                                            fontSize: 25,
                                            color: Colors.white)),
                                  ),
                                  // decoration: BoxDecoration(
                                  //     color: Colors.black.withOpacity(0.5),
                                  //     borderRadius: BorderRadius.circular(10)),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(maxWeight + " KG",
                                        style: GoogleFonts.raleway(
                                            fontSize: 25, color: Colors.white)),
                                  ),
                                  // decoration: BoxDecoration(
                                  //     color: Colors.white,
                                  //     borderRadius: BorderRadius.circular(10)),
                                ),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Your last lift: ",
                                        style: GoogleFonts.inter(
                                            fontSize: 25, color: Colors.white)),
                                  ),
                                  // decoration: BoxDecoration(
                                  //     color: Colors.black.withOpacity(0.5),
                                  //     borderRadius: BorderRadius.circular(10)),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(lastUsedWeight + " KG",
                                        style: GoogleFonts.inter(
                                            fontSize: 25, color: Colors.white)),
                                  ),
                                  // decoration: BoxDecoration(
                                  //     color: Colors.white,
                                  //     borderRadius: BorderRadius.circular(10)),
                                ),

                                //             SmoothPageIndicator(
                                //   controller: _controller,
                                //   count: 3,
                                //   effect: ExpandingDotsEffect(
                                //     activeDotColor: Colors.white,
                                //     dotColor: Colors.white.withOpacity(0.5),
                                //   ),
                                // )
                              ]),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: SmoothPageIndicator(
                        controller: statController,
                        count: 3,
                        effect: ExpandingDotsEffect(
                            activeDotColor: Colors.white,
                            dotColor: Colors.white.withOpacity(0.5),
                            dotHeight: 8,
                            dotWidth: 8,
                            expansionFactor: 2),
                      )))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
