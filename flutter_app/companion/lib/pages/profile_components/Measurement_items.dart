import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MeasureItems extends StatelessWidget {
  final MapEntry<String, double> measurementEntry;
  final Widget muscleIcon;

  MeasureItems({
    Key? key,
    required this.measurementEntry,
    required this.muscleIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: (MediaQuery.of(context).size.width * 0.3649).round().toDouble(),
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: muscleIcon),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  measurementEntry.key,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: (MediaQuery.of(context).size.width * 0.0413)
                          .round()
                          .toDouble()),
                ),
                Text(
                  '${measurementEntry.value} cm',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: (MediaQuery.of(context).size.width * 0.0364)
                          .round()
                          .toDouble()),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
