import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreDisplayPage extends StatefulWidget {
  final Future<Map<String, double>> scoresFuture;
  final String exercise;
  const ScoreDisplayPage(
      {super.key, required this.scoresFuture, required this.exercise});

  @override
  State<ScoreDisplayPage> createState() => _ScoreDisplayPageState();
}

class _ScoreDisplayPageState extends State<ScoreDisplayPage> {
  Map<String, String> keyMap = {
    'mean_ascent_score': 'Ascent Score',
    'mean_descent_score': 'Descent Score',
    'mean_depth_score': 'Depth Score',
  };

  Map<String, String> squatExplanations = {
    'Ascent Score':
        '90-100: Excellent ascending phase! You are using sufficient force and are showing great controll during your ascending phase. Keep it up!\\n60-89: You should be using slightly more force when ascending from the bottom position!\\n60>: Anything lower than 60 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique. If this is the only low score you\'ve got, you should try and use a full range of motion, using sufficient force, almost locking your knees at the top of the movement.',
    'Descent Score':
        '90-100: Excellent descending phase! You are controlling the weight adequately on your descending phase. Keep it up!\\n60-89: You should be a little slower when lowering the weight, make sure to controll the weight! \\n60>: Anything lower than 60 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique. If this is the only low score, check if you\re dropping the weight extremly fast. If the depth score is also low, make sure to reach parallel with the floor as your end point!',
    'Depth Score':
        '90-100: Excellent squat depth! You are reaching very good depth and stay there for long enough. Keep it up!\\n60-89: You\'re almost there! Make sure you stay in the bottom position long enough.\\n60>: Anything lower than 60 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique.'
  };

  Map<String, String> deadliftExplanations = {
    'Ascent Score':
        '100 - 80: Excellent ascent phase! You are using sufficient force and are showing great controll during your ascending phase. Keep it up!\\n80 - 50: You should be slightly more force when ascending from the bottom position!\\n50>: Anything lower than 50 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique.',
    'Descent Score':
        '100 - 80: Excellent ascent phase! You are using sufficient force and are showing great controll during your ascending phase. Keep it up!\\n80 - 50: You should be slightly more force when ascending from the bottom position! \\n50>: Anything lower than 50 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique.',
    'Depth Score':
        '100 - 80: Excellent ascent phase! You are using sufficient force and are showing great controll during your ascending phase. Keep it up!\\n80 - 50: You should be slightly more force when ascending from the bottom position! \\n50>: Anything lower than 50 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique.'
  };

  Map<String, String> benchpressExplanations = {
    'Ascent Score':
        '100 - 80: Excellent ascent phase! You are using sufficient force and are showing great controll during your ascending phase. Keep it up!\\n80 - 50: You should be slightly more force when ascending from the bottom position!\\n50>: Anything lower than 50 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique.',
    'Descent Score':
        '100 - 80: Excellent ascent phase! You are using sufficient force and are showing great controll during your ascending phase. Keep it up!\\n80 - 50: You should be slightly more force when ascending from the bottom position! \\n50>: Anything lower than 50 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique.',
    'Depth Score':
        '100 - 80: Excellent ascent phase! You are using sufficient force and are showing great controll during your ascending phase. Keep it up!\\n80 - 50: You should be slightly more force when ascending from the bottom position! \\n50>: Anything lower than 50 is usually caused by the other scores being low aswell. You might want to adjust your entire squatting technique.'
  };

  String getExplanation(Map explanations, String key, double score) {
    if (score >= 90) {
      return explanations[key]!.split('\\n')[0];
    } else if (score >= 60) {
      return explanations[key]!.split('\\n')[1];
    } else {
      return explanations[key]!.split('\\n')[2];
    }
  }

  Map<String, String> getMap(String exercise) {
    if (exercise == 'squat') {
      return squatExplanations;
    } else if (exercise == 'deadlift') {
      return deadliftExplanations;
    } else {
      return benchpressExplanations;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
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
                Icons.camera,
                color: Colors.white.withOpacity(0.5),
              ),
            )
          ],
        ),
        body: FutureBuilder<Map<String, double>>(
          future: widget.scoresFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.grey[400]));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Overall Score:',
                        style: GoogleFonts.inter(
                            fontSize: 30, color: Colors.white)),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            '${(snapshot.data!.values.reduce((a, b) => a + b) / snapshot.data!.length).round()}',
                            style: GoogleFonts.inter(
                              fontSize: 50,
                              color: (snapshot.data!.values
                                                  .reduce((a, b) => a + b) /
                                              snapshot.data!.length)
                                          .round() >
                                      50
                                  ? Colors.green
                                  : Colors.red,
                            ))),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        (snapshot.data!.values.reduce((a, b) => a + b) /
                                        snapshot.data!.length)
                                    .round() >
                                80
                            ? 'Excellent performance'
                            : (snapshot.data!.values.reduce((a, b) => a + b) /
                                            snapshot.data!.length)
                                        .round() >
                                    50
                                ? 'Good performance'
                                : 'Needs improvement',
                        style: GoogleFonts.inter(
                            fontSize: 25, color: Colors.white),
                      )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String key = snapshot.data!.keys.elementAt(index);
                        double score = snapshot.data![key]!;
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${keyMap[key] ?? key}: ${snapshot.data![key]?.round()}',
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  'Explaination: \n${getExplanation(getMap(widget.exercise), keyMap[key]!, score)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: Colors.white,
                                    height:
                                        1.5, // You can adjust the line height to add space between lines
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
