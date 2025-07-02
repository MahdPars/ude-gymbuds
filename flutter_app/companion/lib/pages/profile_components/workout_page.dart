import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('P U S H',
            style: GoogleFonts.raleway(fontWeight: FontWeight.w300)),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.person,
              color: Colors.white.withOpacity(0.5),
            ),
          )
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height * 0.0118)
                .round()
                .toDouble(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.1423)
                    .round()
                    .toDouble(),
                width: (MediaQuery.of(context).size.height * 0.1423)
                    .round()
                    .toDouble(),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/pepe.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Parssa Mahdavi',
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: (MediaQuery.of(context).size.width * 0.0486)
                            .round()
                            .toDouble(),
                      )),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height * 0.0237)
                        .round()
                        .toDouble(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '6 ',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize:
                                    (MediaQuery.of(context).size.width * 0.0486)
                                        .round()
                                        .toDouble(),
                              ),
                            ),
                            TextSpan(
                              text: 'days\ncurrent streak',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: (MediaQuery.of(context).size.width *
                                          0.0364)
                                      .round()
                                      .toDouble()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width * 0.0486)
                            .round()
                            .toDouble(),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Push\n',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.width *
                                          0.0486)
                                      .round()
                                      .toDouble()),
                            ),
                            TextSpan(
                              text: 'todays workout',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: (MediaQuery.of(context).size.width *
                                          0.0364)
                                      .round()
                                      .toDouble()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
