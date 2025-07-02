import 'package:companion/pages/profile_components/classes/userprofile_class.dart';
import 'package:companion/pages/profile_components/measurements_page.dart';
import 'package:flutter/material.dart';
import 'package:companion/pages/profile_components/Measurement_items.dart';
import 'package:companion/pages/profile_components/profile_workout_items.dart';
import 'package:companion/pages/profile_components/statistic_box.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String token;
  Profile({super.key, required this.token});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List planNameList = [];
  UserProfile? userProfile;
  String movedWeight = "";
  List<String> monthsTrained = [];
  List<double> daysTrainedMonth = [];
  String daysTraining = "";
  Future<void>? _fetchStatisticsFuture;
  int loggingStreak = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchStatisticsFuture = _fetchStatistics();
    get_plans();
  }

  Future<void> _fetchStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/profile_statistic/'),
      headers: {
        "Authorization": "Bearer ${idToken}",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        loggingStreak = jsonData['loggingStreak'];
        daysTraining = jsonData['daysTraining'].toString();
        Map trainingHistory = jsonData['daysTrainedMonth'];
        movedWeight = jsonData['movedWeight'].toString();
        monthsTrained =
            trainingHistory.keys.map((key) => key.toString()).toList();
        daysTrainedMonth = trainingHistory.values
            .map((value) => double.tryParse(value.toString()) ?? 0.0)
            .toList();
        print(monthsTrained);
        print(daysTrainedMonth);
      });
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/fetch_userprofile/'),
        headers: {
          "Authorization": "Bearer ${idToken}",
        });

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> data = jsonDecode(response.body);
        userProfile = UserProfile.fromJson(data['user_profile']);
        print('User profile fetched successfully');
      });
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> get_plans() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/get_plans/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });
    final jsonData = json.decode(response.body);
    setState(() {
      planNameList = List<String>.from(jsonData['workout_name']);
    });

    if (response.statusCode == 200) {
      print("got exercises correctly");
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('P R O F I L E',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w300, color: Colors.white)),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.person,
              color: Colors.white.withOpacity(0.5),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1F1F1F),
        ),
        child: Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.width * 0.0243)
                  .round()
                  .toDouble(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.2919)
                      .round()
                      .toDouble(),
                  width: (MediaQuery.of(context).size.width * 0.2919)
                      .round()
                      .toDouble(),
                  child: ClipOval(
                      child: userProfile == null ||
                              userProfile!.profilePicture == ""
                          ? CircularProgressIndicator()
                          : Image.network(userProfile!.profilePicture,
                              fit: BoxFit.cover)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    userProfile == null
                        ? CircularProgressIndicator()
                        : Text(userProfile!.username,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize:
                                    (MediaQuery.of(context).size.width * 0.0486)
                                        .round()
                                        .toDouble())),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height * 0.01)
                          .round()
                          .toDouble(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: userProfile == null
                                    ? 'Loading...'
                                    : loggingStreak.toString() + ' ',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize:
                                        (MediaQuery.of(context).size.width *
                                                0.0486)
                                            .round()
                                            .toDouble()),
                              ),
                              TextSpan(
                                text: 'days\ncurrent streak',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize:
                                        (MediaQuery.of(context).size.width *
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
                        // RichText(
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: 'Push\n',
                        //         style: GoogleFonts.inter(
                        //             fontWeight: FontWeight.w500,
                        //             color: Colors.white,
                        //             fontSize:
                        //                 (MediaQuery.of(context).size.width *
                        //                         0.0486)
                        //                     .round()
                        //                     .toDouble()),
                        //       ),
                        //       TextSpan(
                        //         text: 'todays workout',
                        //         style: GoogleFonts.inter(
                        //             fontWeight: FontWeight.w300,
                        //             color: Colors.white.withOpacity(0.7),
                        //             fontSize:
                        //                 (MediaQuery.of(context).size.width *
                        //                         0.0364)
                        //                     .round()
                        //                     .toDouble()),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.height * 0.01186)
                      .round()
                      .toDouble()),
              child: SizedBox(
                height: (MediaQuery.of(context).size.height * 0.0533)
                    .round()
                    .toDouble(),
                width: (MediaQuery.of(context).size.width * 0.7615)
                    .round()
                    .toDouble(),
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: const Alignment(-1.0, 0.5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Statistics\n',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'monthly',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.7),
                              fontSize:
                                  (MediaQuery.of(context).size.width * 0.0243)
                                      .round()
                                      .toDouble()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder(
                future: _fetchStatisticsFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError)
                      return Text('Erro: ${snapshot.error}');
                    else
                      return StatisticBox(
                        movedWeight: movedWeight,
                        time: daysTraining,
                        monthlySum: daysTrainedMonth,
                      );
                  }
                }),
            Container(
              width: (MediaQuery.of(context).size.width * 0.7615)
                  .round()
                  .toDouble(),
              height: (MediaQuery.of(context).size.height * 0.0533)
                  .round()
                  .toDouble(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: const Alignment(-1.0, 0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Workouts',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 50,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: planNameList.length,
                  itemBuilder: (context, index) {
                    return ProfileWorkout(workout: planNameList[index]);
                  }),
            ),
            Container(
              width: (MediaQuery.of(context).size.width * 0.7615)
                  .round()
                  .toDouble(),
              height: (MediaQuery.of(context).size.height * 0.0533)
                  .round()
                  .toDouble(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: (MediaQuery.of(context).size.width * 0.01946)
                        .round()
                        .toDouble()),
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: const Alignment(-1.0, 0.5),
                  child: Row(
                    children: [
                      Text(
                        'Measurements',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 50),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: (userProfile?.measurements.entries ?? []).map((e) {
                  String iconPath =
                      'assets/icons/${e.key.toLowerCase().replaceAll(' ', '_').replaceAll('right', 'left')}_measurement.svg';
                  bool shouldMirror = e.key.toLowerCase().contains('right');

                  return GestureDetector(
                    onTap: () {
                      String iconPath =
                          'assets/icons/${e.key.toLowerCase().replaceAll(' ', '_').replaceAll('right', 'left')}_measurement.svg';
                      bool shouldMirror = e.key.toLowerCase().contains('right');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeasurementsPage(
                            userProfile: userProfile,
                            measurementName: e.key,
                            iconPath: iconPath,
                            mirror: shouldMirror,
                          ),
                        ),
                      );
                    },
                    child: MeasureItems(
                      measurementEntry: e,
                      muscleIcon: shouldMirror
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..scale(-1.0, 1.0),
                                child: FittedBox(
                                  child: SvgPicture.asset(
                                    iconPath,
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                    width: 50,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: SvgPicture.asset(
                                  iconPath,
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                  width: 50,
                                ),
                              ),
                            ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height * 0.0355)
                  .round()
                  .toDouble(),
            )
          ],
        ),
      ),
    );
  }
}
