// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:companion/pages/overview_components/WO_Sets_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseItem extends StatefulWidget {
  String exerciseName = "";

  ExerciseItem({
    super.key,
    required this.exerciseName,
  });

  @override
  State<ExerciseItem> createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  @override
  void initState() {
    super.initState();
    get_todays_sets();
    // addCurrentWO();
  }

  final List<String> setsList = [];
  final List<String> weightList = [];
  final List<String> repList = [];
  List completeList = [];

  Future<void> track_stat() async {
    final body = {
      "set": setsList[0],
      "weight": weightList[0],
      "reps": repList[0],
      "exerciseID": widget.exerciseName,
    };
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';

    final response = await http.post(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/track_statistic/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      print("tracked stats correctly");
      await get_todays_sets();
    } else {
      throw Exception('Failed to track stats correctly');
    }
  }

  Future<void> track_maxlast() async {
    final body = {
      "newWeight": weightList[0],
      "exerciseID": widget.exerciseName,
    };
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';

    final response = await http.post(
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/track_maxlast/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      print("added new statistic correctly");
    } else {
      throw Exception('Failed to add new statistic to db');
    }
  }

  Future<void> get_todays_sets() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse(
            'http://${dotenv.env['SERVER_IP']}:8000/get_todays_sets/${widget.exerciseName}/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });
    final jsonData = json.decode(response.body);
    setState(() {
      completeList = jsonData['setsList'];
    });

    if (response.statusCode == 200) {
      print("got exercises correctly");
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<void> refreshPage() async {
    await get_todays_sets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _weightInput = TextEditingController();
    TextEditingController _setInput = TextEditingController();
    TextEditingController _repInput = TextEditingController();

    void _addSetAndWeight() {
      setState(() {
        setsList.add(_setInput.text);
        weightList.add(_weightInput.text);
        repList.add(_repInput.text);

        _setInput.clear();
        _weightInput.clear();
        _repInput.clear();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.exerciseName,
          style: GoogleFonts.raleway(
              fontWeight: FontWeight.w300, color: Colors.white),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white.withOpacity(0.5),
        ),
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
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF1F1F1F)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Add a new set for ' + widget.exerciseName,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Colors.white)),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF545454),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _weightInput,
                      // onChanged: (value) {
                      //   // setState(() {});
                      // },
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' used weight',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF545454),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _setInput,
                      // onChanged: (value) {
                      //   // setState(() {});
                      // },
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: " current set",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF545454),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _repInput,
                      // onChanged: (value) {
                      //   // setState(() {});
                      // },
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // ],
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' reps done',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: GestureDetector(
                onTap: () {
                  _addSetAndWeight();
                  track_maxlast();
                  track_stat();
                  refreshPage();
                  setsList.clear();
                  weightList.clear();
                  repList.clear();
                },
                child: Container(
                  height: 50,
                  width: 200,
                  child: Center(
                      child: Text(
                    'add your set and weight!',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              // height: 25,
              padding: EdgeInsets.only(left: 8, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Your sets of today",
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: completeList.length,
                itemBuilder: (context, index) {
                  var exer = completeList[index];
                  return wo_SetsItems(
                    sets: exer['sets'],
                    weight: exer['weight'],
                    reps: exer['reps'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
