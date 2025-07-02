// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:companion/pages/workouts_components/a_exercise_items.dart';
import 'package:companion/pages/workouts_components/add_workout_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddWorkout extends StatefulWidget {
  AddWorkout({super.key});

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  String exerciseName = "";
  List exerciseList = [];
  final _textController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    get_all_exercises();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> get_all_exercises() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    String url = 'http://${dotenv.env['SERVER_IP']}:8000/get_all_exercises';
    if (exerciseName.isNotEmpty) {
      url += '/$exerciseName';
    }
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${idToken}"
    });
    final jsonData = json.decode(response.body);
    setState(() {
      isLoading = false;
      exerciseList = jsonData['exercise_list'];
    });
    if (response.statusCode == 200) {
      print("got exercises correctly");
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> muskelgruppen = [
      "Chest",
      "Lats",
      "Delts",
      "Biceps",
      "Triceps",
      "Quadriceps",
      "Glutes",
      "Calves",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
        title: Text('All Exercises',
            style: GoogleFonts.inter(color: Colors.white)),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
              child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          )),
        ),
      ),
      body: Container(
        color: Color(0xFF1F1F1F),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                color: Color(0xFF545454),
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: TextField(
                  controller: _textController,
                  onSubmitted: (value) {
                    setState(() {
                      exerciseName = value;
                    });
                    get_all_exercises();
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add your workout',
                      hintStyle: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.5), fontSize: 17),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _textController.clear();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ))),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: muskelgruppen.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          exerciseName = muskelgruppen[index];
                        });
                        get_all_exercises();
                      },
                      child: AddWoItems(exercise: muskelgruppen[index]),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.grey[400]),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Scrollbar(
                        thickness: 7,
                        thumbVisibility: true,
                        interactive: true,
                        radius: Radius.circular(5),
                        scrollbarOrientation: ScrollbarOrientation.left,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 4),
                          child: ListView.builder(
                              itemCount: exerciseList.length,
                              itemBuilder: (context, index) {
                                return exercise_items(
                                    exerciseName: exerciseList[index]);
                              }),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
