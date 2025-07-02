import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class WorkoutItems extends StatelessWidget {
  String iconPath = '';
  String muscle = '';
  String exercise = '';
  String reps = '';
  String status = '';
  Color statusColor;
  Color statusTextColor;

  WorkoutItems(
      {super.key,
      required this.iconPath,
      required this.muscle,
      required this.exercise,
      required this.reps,
      required this.status,
      required this.statusColor,
      required this.statusTextColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Container(
        height:
            (MediaQuery.of(context).size.height * 0.1352).round().toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[800],
          // border: Border(
          //     bottom: BorderSide(
          //   color: Colors.blue,
          //   width: 5,
          // )
          // )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                muscle,
                style: GoogleFonts.inter(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                softWrap: true,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise,
                    style: GoogleFonts.inter(
                        fontSize: (MediaQuery.of(context).size.width * 0.0486)
                            .round()
                            .toDouble(),
                        // fontWeight: FontWeight.w400,
                        color: Colors.white)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: reps,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.width * 0.0486)
                              .round()
                              .toDouble(),
                          // fontWeight: FontWeight.w500
                        ),
                      ),
                      TextSpan(
                        text: ' Reps',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.width * 0.0486)
                              .round()
                              .toDouble(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 2),
                    child: Center(
                      child: Text(status,
                          style: GoogleFonts.inter(
                              color: statusTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                )
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 45,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
