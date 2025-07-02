// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class exercise_items extends StatelessWidget {
  String exerciseName = "";
  exercise_items({super.key, required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            exerciseName,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Size _calculateTextSize(String text, BuildContext context) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: GoogleFonts.inter(fontSize: 20)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return painter.size;
  }
}
