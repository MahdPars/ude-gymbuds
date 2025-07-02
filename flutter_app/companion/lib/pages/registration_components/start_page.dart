import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:companion/pages/registration_components/classes/registrationdata.dart';

class StartPage extends StatelessWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;

  const StartPage({
    Key? key,
    required this.registrationData,
    required this.navigateToNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/pxfuel.jpg'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Gymbuds!',
                style: GoogleFonts.inter(
                  fontSize: 52.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Let\'s begin your journey.',
                style: GoogleFonts.raleway(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  // TODO: Navigate to the registration page
                  navigateToNextPage();
                },
                child: Text(
                  'Let\'s Get Started',
                  style: GoogleFonts.raleway(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
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
