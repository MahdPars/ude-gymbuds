import 'dart:convert';
import 'package:companion/pages/overview_components/animation.dart';
import 'package:companion/pages/overview_components/exercise_widget.dart';
import 'package:companion/pages/overview_components/o_exercise_items.dart';
import 'package:companion/pages/overview_components/plan_items.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:companion/pages/overview_components/weekdays__items.dart';
import 'package:companion/pages/overview_components/workout_items.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List exerciseList = [];
  List planNameList = [];
  bool isLoading = true;
  String planName = "";
  bool firstLogin = true;
  @override
  void initState() {
    super.initState();
    check_first_login();
  }

  Future<void> get_plans_exercises(String planName) async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse(
            'http://${dotenv.env['SERVER_IP']}:8000/get_plans_exercises/${planName}/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });
    final jsonData = json.decode(response.body);
    print(jsonData);
    setState(() {
      exerciseList = jsonData['exercise_list'];
    });

    if (response.statusCode == 200) {
      print("got exercises correctly");
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<void> make_plans() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/make_plans/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });
    if (response.statusCode == 200) {
      print("got exercises correctly");
      await update_first_login();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<void> update_first_login() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.post(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/update_first_login/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });

    if (response.statusCode == 200) {
      print("got exercises correctly");
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<void> check_first_login() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/check_first_login/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      firstLogin = jsonData['check_first_login'];
      if (firstLogin) {
        await make_plans();
        await get_plans();
        setState(() {});
      } else {
        await get_plans();
        setState(() {});
      }
    } else {
      throw Exception('Failed to check first login status');
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
      isLoading = false;
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
    String getMonthName(int monthNumber) {
      List<String> monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "September",
        "October",
        "November",
        "December"
      ];
      return monthNames[monthNumber - 1];
    }

    String getCurrentMonthName() {
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      return getMonthName(currentMonth);
    }

    DateTime currentDateTime = DateTime.now();

    int day = currentDateTime.day;

    List<String> _wochenTag = [];

    for (int i = 0; i < 8; i++) {
      switch (currentDateTime.add(Duration(days: i)).weekday) {
        case 1:
          _wochenTag.add('Mon');
        case 3:
          _wochenTag.add('Wed');
          break;
        case 2:
          _wochenTag.add('Tue');
        case 4:
          _wochenTag.add('Thu');
          break;
        case 5:
          _wochenTag.add('Fri');
          break;
        case 6:
          _wochenTag.add('Sat');
        case 7:
          _wochenTag.add('Sun');
          break;
      }
    }

    List<int> _tageDatum = [];

    for (int i = 0; i < 7; i++) {
      _tageDatum.add(day + i);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
        title: Text('O V E R V I E W',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w300, color: Colors.white)),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.content_paste,
              color: Colors.white.withOpacity(0.5),
            ),
          )
        ],
      ),
      body: isLoading
          ? Container(
              color: Color(0xFF1F1F1F),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.grey[400],
              )),
            )
          : Container(
              decoration: BoxDecoration(color: Color(0xFF1F1F1F)),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 10, bottom: 5, left: 10),
                    child: Container(
                      height: 125,
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 19.0, bottom: 12),
                                child: Container(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      getCurrentMonthName(),
                                      style: GoogleFonts.inter(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    WeekdaysItems(
                                      weekday: _wochenTag[0],
                                      daydate: _tageDatum[0],
                                    ),
                                    WeekdaysItems(
                                      weekday: _wochenTag[1],
                                      daydate: _tageDatum[1],
                                    ),
                                    WeekdaysItems(
                                      weekday: _wochenTag[2],
                                      daydate: _tageDatum[2],
                                    ),
                                    WeekdaysItems(
                                      weekday: _wochenTag[3],
                                      daydate: _tageDatum[3],
                                    ),
                                    WeekdaysItems(
                                      weekday: _wochenTag[4],
                                      daydate: _tageDatum[4],
                                    ),
                                    WeekdaysItems(
                                      weekday: _wochenTag[5],
                                      daydate: _tageDatum[5],
                                    ),
                                    WeekdaysItems(
                                      weekday: _wochenTag[6],
                                      daydate: _tageDatum[6],
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 15),
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Exercises",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  Expanded(
                      child: planNameList.isNotEmpty
                          ? ListView.builder(
                              itemCount: planNameList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ExpansionTile(
                                    collapsedIconColor: Colors.white,
                                    iconColor: Colors.white.withOpacity(0.5),
                                    collapsedBackgroundColor: Colors.grey[800],
                                    backgroundColor: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    collapsedShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: Text(
                                      planNameList[index],
                                      style: GoogleFonts.inter(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onExpansionChanged: (bool expanded) {
                                      if (expanded) {
                                        get_plans_exercises(
                                            planNameList[index]);
                                      }
                                    },
                                    children: <Widget>[
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: exerciseList.length,
                                          itemBuilder: (context, innerIndex) {
                                            String exerciseName =
                                                exerciseList[innerIndex];
                                            return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExerciseItem(
                                                                  exerciseName:
                                                                      exerciseName)));
                                                },
                                                child: exerciseWidget(
                                                    exerciseName:
                                                        exerciseName));
                                          })
                                    ],
                                  ),
                                );
                              })
                          : Container(
                              color: Color(0xFF1F1F1F),
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                  child: Text(
                                "No Overview available",
                                style: TextStyle(color: Colors.white),
                              ))))
                ],
              ),
            ),
    );
  }
}
