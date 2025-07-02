import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:companion/pages/registration_components/classes/registrationdata.dart';

class TrainingFrequencyPage extends StatefulWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;
  final Function navigateToPreviousPage;

  const TrainingFrequencyPage({
    Key? key,
    required this.registrationData,
    required this.navigateToNextPage,
    required this.navigateToPreviousPage,
  }) : super(key: key);

  @override
  State<TrainingFrequencyPage> createState() => _TrainingFrequencyPageState();
}

class _TrainingFrequencyPageState extends State<TrainingFrequencyPage> {
  int? _selectedFrequency = 0;
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
                      'Frequency',
                      style:
                          GoogleFonts.inter(fontSize: 54, color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Last step! How often do you want to train in a week? You can always change this setting later!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (_selectedFrequency == 2) {
                                  return Colors.green.withOpacity(0.7);
                                }
                                return Colors.grey[300]!;
                              }),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedFrequency = 2;
                              });
                            },
                            child: Text(
                              '2 Days',
                              style: GoogleFonts.raleway(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (_selectedFrequency == 3) {
                                  return Colors.green.withOpacity(0.7);
                                }
                                return Colors.grey[300]!;
                              }),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedFrequency = 3;
                              });
                            },
                            child: Text(
                              '3 Days',
                              style: GoogleFonts.raleway(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (_selectedFrequency == 4) {
                                  return Colors.green.withOpacity(0.7);
                                }
                                return Colors.grey[300]!;
                              }),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedFrequency = 4;
                              });
                            },
                            child: Text(
                              '4 Days',
                              style: GoogleFonts.raleway(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (_selectedFrequency == 5) {
                                  return Colors.green.withOpacity(0.7);
                                }
                                return Colors.grey[300]!;
                              }),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedFrequency = 5;
                              });
                            },
                            child: Text(
                              '5 Days',
                              style: GoogleFonts.raleway(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 10),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10)),
                          onPressed: () {
                            widget.registrationData.frequency =
                                _selectedFrequency!;
                            widget.navigateToNextPage();
                          },
                          child: Text(
                            'Continue',
                            style: GoogleFonts.raleway(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ]),
            )));
  }
}
