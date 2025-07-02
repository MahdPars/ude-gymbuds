import 'package:companion/pages/registration_components/classes/registrationdata.dart';
import 'package:companion/pages/registration_components/components/tiles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeightSelectionPage extends StatefulWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;
  final Function navigateToPreviousPage;
  const HeightSelectionPage(
      {super.key,
      required this.registrationData,
      required this.navigateToNextPage,
      required this.navigateToPreviousPage});

  @override
  State<HeightSelectionPage> createState() => _HeightSelectionPageState();
}

class _HeightSelectionPageState extends State<HeightSelectionPage> {
  int selectedValue = 120;
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
            Text('Select your height',
                style: GoogleFonts.inter(
                  fontSize: 54,
                  color: Colors.white,
                )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'We ask for your height to customize workouts, ensuring exercises match your physique and fitness goals for the best experience.',
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
                    childCount: 120,
                    builder: (context, index) {
                      return Tile(
                        value: index + 120,
                        onTap: () {
                          setState(() {
                            selectedValue = index + 120;
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
                    registrationData.height = selectedValue.toDouble();
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
