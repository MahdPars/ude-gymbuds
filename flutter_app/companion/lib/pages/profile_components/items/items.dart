import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:companion/pages/profile_components/classes/userprofile_class.dart';

Widget createMeasurementItem({
  required String iconPath,
  required String measurementName,
  required UserProfile? userProfile,
  bool mirror = false,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
    decoration: BoxDecoration(
      color: Colors.grey[700],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2.5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          width: 100,
          height: 100,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror ? 3.14159 : 0),
            child: SvgPicture.asset(iconPath, color: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2.5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Text(
                  'Current ${measurementName}: ${userProfile?.measurements[measurementName]}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your measurement',
                      hintStyle: GoogleFonts.inter(color: Colors.white)),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    userProfile?.measurements[measurementName] =
                        double.parse(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
