import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class wo_SetsItems extends StatelessWidget {
  String sets = "";
  String weight = "";
  String reps = "";
  wo_SetsItems(
      {super.key,
      required this.sets,
      required this.weight,
      required this.reps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Center(
                      child: Text(
                "Set: " + sets,
                style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
              ))),
              Expanded(
                  child: Center(
                      child: Text(
                "Weight: " + weight,
                style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
              ))),
              Expanded(
                  child: Center(
                      child: Text(
                "Reps: " + reps,
                style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
              )))
            ],
          ),
        ),
      ),
    );
  }
}
