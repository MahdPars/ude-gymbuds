import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:companion/pages/registration_components/classes/registrationdata.dart';

class ExperiencePage extends StatefulWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;
  final Function navigateToPreviousPage;

  const ExperiencePage(
      {Key? key,
      required this.registrationData,
      required this.navigateToNextPage,
      required this.navigateToPreviousPage})
      : super(key: key);

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  int? _selectedExperience = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pxfuel.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Experience',
                style: GoogleFonts.inter(fontSize: 54, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'In the final step, we\'ll need information on your level of experience and what goal you have.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              // Experience Selection
              Text(
                'Select your experience level',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (_selectedExperience == 0) {
                        return Colors.green.withOpacity(0.7);
                      }
                      return Colors.grey[300]!;
                    }),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedExperience = 0;
                    });
                  },
                  child: Text(
                    'Beginner',
                    style:
                        GoogleFonts.raleway(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (_selectedExperience == 1) {
                        return Colors.green.withOpacity(0.7);
                      }
                      return Colors.grey[300]!;
                    }),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 83, vertical: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedExperience = 1;
                    });
                  },
                  child: Text(
                    'Intermediate',
                    style:
                        GoogleFonts.raleway(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (_selectedExperience == 2) {
                        return Colors.green.withOpacity(0.7);
                      }
                      return Colors.grey[300]!;
                    }),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 95, vertical: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedExperience = 2;
                    });
                  },
                  child: Text(
                    'Advanced',
                    style:
                        GoogleFonts.raleway(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button color
                      foregroundColor: Colors.black, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Circular edges
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    ),
                    onPressed: () {
                      widget.navigateToPreviousPage();
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
                      widget.registrationData.experience = _selectedExperience!;
                      widget.navigateToNextPage();
                    },
                    child: Text(
                      'Continue',
                      style: GoogleFonts.raleway(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ));
  }
}
