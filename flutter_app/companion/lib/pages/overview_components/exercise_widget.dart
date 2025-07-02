// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class exerciseWidget extends StatelessWidget {
  String exerciseName = "";
  exerciseWidget({super.key, required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[700], borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                exerciseName,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7.0),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
