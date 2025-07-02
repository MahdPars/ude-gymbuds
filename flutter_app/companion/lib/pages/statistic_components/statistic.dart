import 'package:flutter/material.dart';
import 'package:companion/pages/statistic_components/statistic_items.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  List statsList = [];
  List weightList = [];
  List<double> weightdouble = [];
  bool isLoading = true;
  String maxWeight = "";
  String exerciseName = "";
  String lastUsedWeight = "";
  @override
  void initState() {
    super.initState();
    get_stats();
  }

  Future<void> get_stats() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/get_stats/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });
    final jsonData = json.decode(response.body);
    setState(() {
      isLoading = false;
      statsList = jsonData['statList'];
      weightList = jsonData['weightlist'];
      for (var wei in weightList) {
        print(wei);
        weightdouble.add(double.parse(wei));
      }
      for (var stat in statsList) {
        print(stat['exerciseID']);
      }
      print(statsList.length);
    });

    if (response.statusCode == 200) {
      print("got statistics correctly");
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _controller = PageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'S T A T I S T I C',
          style: GoogleFonts.raleway(fontWeight: FontWeight.w300),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.signal_cellular_alt,
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
              )))
          : Container(
              decoration: BoxDecoration(color: Color(0xFF1F1F1F)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      height: (MediaQuery.of(context).size.height * 0.6431)
                          .round()
                          .toDouble(),
                      child: statsList.isNotEmpty
                          ? PageView(
                              controller: _controller,
                              children: statsList.map((stat) {
                                List<double> weightsList =
                                    stat['weightList'].map<double>((wei) {
                                  return double.tryParse(wei) ?? 0.0;
                                }).toList();
                                return StatisticItems(
                                  weightsList: weightsList,
                                  maxWeight: stat['maxWeight'],
                                  exerciseName: stat['exerciseID'],
                                  lastUsedWeight: stat['lastUsedWeight'],
                                  tendency: stat['tendency'],
                                );
                              }).toList(),
                            )
                          : Container(
                              color: Color(0xFF1F1F1F),
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                  child: Text(
                                "No statistics available",
                                style: TextStyle(color: Colors.white),
                              )))),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: statsList.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.5),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
