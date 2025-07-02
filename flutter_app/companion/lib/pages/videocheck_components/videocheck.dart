import 'package:companion/pages/videocheck_components/subpages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Videocheck extends StatefulWidget {
  const Videocheck({super.key});

  @override
  State<Videocheck> createState() => _VideocheckState();
}

class _VideocheckState extends State<Videocheck> {
  XFile? _pickedVideo;
  Map<String, double> lastScores = {
    'Squat': 100,
    'Deadlift': 100,
    'Benchpress': 100,
  };

  Future<void> _fetchScoringHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse(
            'http://${dotenv.env['SERVER_IP']}:8000/fetch_scoring_history/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });

    if (response.statusCode == 200) {
      final content = json.decode(response.body);
      final scoringHistory = content['scoring_history'];
      final scores = scoringHistory[0];

      Map<String, Map<String, dynamic>> exercises = {
        'Squat': scores['squat_scores'],
        'Deadlift': scores['deadlift_scores'],
        'Benchpress': scores['benchpress_scores'],
      };

      Map<String, double> meanScores = {};

      exercises.forEach((exercise, Map<String, dynamic> scores) {
        double totalDescent = 0.0;
        double totalAscent = 0.0;
        double totalDepth = 0.0;

        scores.forEach((key, dynamic score) {
          totalDescent += score as double;
          totalAscent += score;
          totalDepth += score;
        });

        double meanDescent = totalDescent / scores.length;
        double meanAscent = totalAscent / scores.length;
        double meanDepth = totalDepth / scores.length;

        double overallScore = (meanDescent + meanAscent + meanDepth) / 3;

        meanScores[exercise] = overallScore;
      });

      setState(() {
        lastScores = meanScores;
      });
    } else {
      print('Failed to fetch scoring history');
    }
  }

  Future<Map<String, double>> _uploadVideoAndLoadScores(
      XFile video, String exerciseName) async {
    // We need a multipart request because we are sending a file
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/upload_video/'),
    );
    request.headers.addAll({"Authorization": "Bearer ${idToken}"});
    // Adding the file to our request
    request.files.add(await http.MultipartFile.fromPath(
      'video',
      video.path,
    ));

    // Add Exercise Name to our Request
    request.fields['exercise_name'] = exerciseName;
    // Sending the request
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded!');

      // Get response Body as a Stream
      var responseBody = await response.stream.bytesToString();

      // Parse JSON object
      var content = jsonDecode(responseBody);
      var scores = content['content'];

      // Update the last scores with new received scores
      return scores.map<String, double>((key, value) =>
          MapEntry<String, double>(
              key as String, (value * 100).roundToDouble() / 100));
    } else {
      print('Failed to upload');
      throw Exception('Failed to upload video');
    }
  }

  Future<void> _pickVideo(String exerciseName) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _pickedVideo = video;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreDisplayPage(
              exercise: exerciseName,
              scoresFuture: _uploadVideoAndLoadScores(video, exerciseName)),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchScoringHistory();
    WidgetsBinding.instance
      ..addPostFrameCallback((timeStamp) {
        _showWelcomeDialog();
      });
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Disclaimer',
            style: GoogleFonts.inter(fontWeight: FontWeight.w300),
          ),
          content: Text(
            'This is a beta feature. Please do not rely on the scores given by the app. The app is not responsible for any injuries caused by the use of this feature.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w300),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'V I D E O C H E C K',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w300, color: Colors.white),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.visibility,
                color: Colors.white.withOpacity(0.5),
              ))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1F1F1F),
        ),
        child: Column(
          children: lastScores.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                height: (MediaQuery.of(context).size.height * 0.1352)
                    .round()
                    .toDouble(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey[800],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            entry.key,
                            style: GoogleFonts.inter(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Last score: ',
                            style: GoogleFonts.inter(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: (entry.value.isInfinite || entry.value.isNaN)
                                ? ' - '
                                : entry.value.round().toString(),
                            style: GoogleFonts.inter(
                                fontSize:
                                    (MediaQuery.of(context).size.width * 0.0486)
                                        .round()
                                        .toDouble(),
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Rate your form',
                            style: GoogleFonts.inter(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                            print(entry.key.toLowerCase());
                            _pickVideo(entry.key.toLowerCase());
                          },
                          child: Text(
                            'Upload Video',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
