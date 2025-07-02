import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:companion/pages/profile_components/items/items.dart';
import 'package:companion/pages/profile_components/classes/userprofile_class.dart';
import 'package:companion/pages/profile_components/utils/updateprofile.dart';

class MeasurementsPage extends StatefulWidget {
  final UserProfile? userProfile;
  final String measurementName;
  final String iconPath;
  final bool mirror;

  const MeasurementsPage({
    super.key,
    required this.userProfile,
    required this.measurementName,
    required this.iconPath,
    this.mirror = false,
  });

  @override
  State<MeasurementsPage> createState() => _MeasurementsPageState();
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.measurementName,
          style: GoogleFonts.inter(
            fontSize: 25,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  createMeasurementItem(
                    iconPath: widget.iconPath,
                    measurementName: widget.measurementName,
                    userProfile: widget.userProfile,
                    mirror: widget.mirror,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                )),
            onPressed: () {
              updateUserProfile(widget.userProfile!);
              Navigator.of(context).pop();
            },
            child: Text(
              'Apply Changes',
              style: GoogleFonts.inter(fontSize: 16),
            ),
          ),
        ]),
      ),
    );
  }
}
