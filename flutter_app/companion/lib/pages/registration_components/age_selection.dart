import 'package:companion/pages/registration_components/classes/registrationdata.dart';
import 'package:companion/pages/registration_components/components/tiles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgeSelectionPage extends StatefulWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;
  final Function navigateToPreviousPage;
  const AgeSelectionPage(
      {super.key,
      required this.registrationData,
      required this.navigateToNextPage,
      required this.navigateToPreviousPage});

  @override
  State<AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  int selectedValue = 14;
  @override
  Widget build(BuildContext context) {
    RegistrationData registrationData = widget.registrationData;
    Function navigateToNextPage = widget.navigateToNextPage;
    Function navigateToPreviousPage = widget.navigateToPreviousPage;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/pxfuel.jpg'),
              fit: BoxFit.cover)),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            Text('Select your age',
                style: GoogleFonts.inter(
                  fontSize: 54,
                  color: Colors.white,
                )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Safety and suitability are important. We request your age to customize workouts, considering your fitness level and health for a safer and more effective training experience.',
                style: GoogleFonts.raleway(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 450,
              child: ListWheelScrollView.useDelegate(
                  itemExtent: 100,
                  perspective: 0.002,
                  diameterRatio: 1.7,
                  overAndUnderCenterOpacity: 0.5,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 100,
                    builder: (context, index) {
                      return Tile(
                        value: index + 14,
                        onTap: () {
                          setState(() {
                            selectedValue = index + 14;
                          });
                        },
                      );
                    },
                  )),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button color
                    foregroundColor: Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Circular edges
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  ),
                  onPressed: () {
                    navigateToPreviousPage();
                  },
                  child: Text(
                    'Back',
                    style: GoogleFonts.raleway(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button color
                      foregroundColor: Colors.black, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Circular edges
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                  onPressed: () {
                    registrationData.age = selectedValue;
                    navigateToNextPage();
                  },
                  child: Text(
                    'Continue',
                    style: GoogleFonts.raleway(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
