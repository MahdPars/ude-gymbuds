import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AddWoItems extends StatefulWidget {
  String exercise = '';

  AddWoItems({super.key, required this.exercise});

  @override
  State<AddWoItems> createState() => _AddWoItemsState();
}

class _AddWoItemsState extends State<AddWoItems> {
  @override
  Widget build(BuildContext context) {
    final textSize = _calculateTextSize(widget.exercise, context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: textSize.width + 40,
        decoration: BoxDecoration(
            color: Color(0xff404040),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              widget.exercise,
              style: GoogleFonts.inter(fontSize: 20, color: Colors.white),
            ),
          ),
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
