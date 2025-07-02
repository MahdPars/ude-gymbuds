// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:companion/pages/profile_components/workout_page.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileWorkout extends StatelessWidget {
  String workout = '';

  ProfileWorkout({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final textSize = _calculateTextSize(workout, context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Container(
        width: textSize.width + 40,
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(workout,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20,
              )),
        ),
      ),
    );
  }

  Size _calculateTextSize(String text, BuildContext context) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
          text: text,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return painter.size;
  }
}
