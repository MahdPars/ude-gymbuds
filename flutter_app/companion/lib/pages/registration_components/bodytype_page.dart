import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:companion/pages/registration_components/classes/registrationdata.dart';

class BodyType extends StatelessWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;
  final Function navigateToPreviousPage;

  const BodyType(
      {Key? key,
      required this.registrationData,
      required this.navigateToNextPage,
      required this.navigateToPreviousPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedBodyType = ValueNotifier<int>(0);

    return Scaffold(
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
                'Body Type',
                style: GoogleFonts.inter(
                  fontSize: 54,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'In the next few steps, we\'ll need some personal information to tailor your experience to your needs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<int>(
                valueListenable: selectedBodyType,
                builder: (context, value, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          selectedBodyType.value = 1;
                        },
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/icons/male.png'),
                              fit: BoxFit.cover,
                            ),
                            gradient: value == 1
                                ? LinearGradient(
                                    colors: [
                                      Colors.green[100]!,
                                      Colors.green[500]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          selectedBodyType.value = 2;
                        },
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/icons/female.png'),
                              fit: BoxFit.cover,
                            ),
                            gradient: value == 2
                                ? LinearGradient(
                                    colors: [
                                      Colors.green[100]!,
                                      Colors.green[500]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 10,
                        )),
                    onPressed: () {
                      navigateToPreviousPage();
                    },
                    child: Text(
                      'Back',
                      style: GoogleFonts.raleway(fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 20),
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
                      if (selectedBodyType.value != 0) {
                        registrationData.bodyType = selectedBodyType.value;
                        navigateToNextPage();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a body type'),
                          ),
                        );
                      }
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
      ),
    );
  }
}
