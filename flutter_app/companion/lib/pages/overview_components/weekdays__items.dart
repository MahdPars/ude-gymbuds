import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekdaysItems extends StatelessWidget {
  final String weekday;
  final int daydate;

  WeekdaysItems({required this.weekday, required this.daydate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // gradient: LinearGradient(
          //     colors: [Color(0xffA1A1A1).withOpacity(0.8), Color(0xff47E6D3)],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter),
          // color: Colors.grey[600]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  child: Text(
                    weekday,
                    style: GoogleFonts.inter(
                        // fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.width * 0.02433)
                    .round()
                    .toDouble(),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    daydate.toString(),
                    style: GoogleFonts.inter(
                        // fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
