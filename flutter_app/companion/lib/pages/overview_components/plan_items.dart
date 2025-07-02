// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class planItems extends StatelessWidget {
  String planName = "";
  planItems({super.key, required this.planName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                planName,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 25),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 45,
              color: Colors.white,
            ),
          ],
        )),
      ),
    );
  }
}
