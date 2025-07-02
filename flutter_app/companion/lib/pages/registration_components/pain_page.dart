import 'package:companion/auth/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:companion/pages/registration_components/classes/registrationdata.dart';

class PainPointPage extends StatefulWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;
  final Function navigateToPreviousPage;

  const PainPointPage(
      {Key? key,
      required this.registrationData,
      required this.navigateToNextPage,
      required this.navigateToPreviousPage})
      : super(key: key);

  @override
  State<PainPointPage> createState() => _PainPointPageState();
}

class _PainPointPageState extends State<PainPointPage> {
  List<bool> _selectedPainPoints = [false, false, false, false];

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
                'Pain Points',
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
                'Select points on your body where you experience pain while working out.',
                textAlign: TextAlign.center,
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
                child: Container(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (_selectedPainPoints[0]) {
                          return Colors.green.withOpacity(0.7);
                        }
                        return Colors.grey[300]!;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedPainPoints[0] = !_selectedPainPoints[0];
                      });
                    },
                    child: Text(
                      'Shoulders',
                      style: GoogleFonts.raleway(
                        color: _selectedPainPoints[0]
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (_selectedPainPoints[1]) {
                          return Colors.green.withOpacity(0.7);
                        }
                        return Colors.grey[300]!;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedPainPoints[1] = !_selectedPainPoints[1];
                      });
                    },
                    child: Text(
                      'Knees',
                      style: GoogleFonts.raleway(
                        color: _selectedPainPoints[1]
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (_selectedPainPoints[2]) {
                          return Colors.green.withOpacity(0.7);
                        }
                        return Colors.grey[300]!;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedPainPoints[2] = !_selectedPainPoints[2];
                      });
                    },
                    child: Text(
                      'Lower Back',
                      style: GoogleFonts.raleway(
                        color: _selectedPainPoints[2]
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (_selectedPainPoints[3]) {
                          return Colors.green.withOpacity(0.7);
                        }
                        return Colors.grey[300]!;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedPainPoints[3] = !_selectedPainPoints[3];
                      });
                    },
                    child: Text(
                      'None',
                      style: GoogleFonts.raleway(
                        color: _selectedPainPoints[3]
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                      ),
                    ),
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
                    onPressed: () async {
                      widget.registrationData.painPoints = _selectedPainPoints;
                      try {
                        await singUp(widget.registrationData);
                        widget.navigateToNextPage();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error ${e.toString()}'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Sign Up!',
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
