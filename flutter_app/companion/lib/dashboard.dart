import 'dart:convert';
import 'package:companion/pages/workouts_components/add_workout.dart';
import 'package:flutter/material.dart';
import 'package:companion/pages/overview_components/overview.dart';
import 'package:companion/pages/profile_components/profile.dart';
import 'package:companion/pages/statistic_components/statistic.dart';
import 'package:companion/pages/videocheck_components/videocheck.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({super.key, required this.token});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  String exerciseName = "Lats";
  late List<Widget> _pages;
  String planName = "PullL";

  @override
  void initState() {
    super.initState();

    _pages = [
      const Videocheck(),
      const Statistic(),
      const Overview(),
      Profile(token: widget.token),
    ];
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
    } else {
      throw Exception('Failed to load exercises');
    }
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
    setState(() {});
    if (response.statusCode == 200) {
      print("got exercises correctly");
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<void> get_plans_exercises() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token') ?? '';
    final response = await http.get(
        Uri.parse(
            'http://${dotenv.env['SERVER_IP']}:8000/get_plans_exercises/${planName}/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${idToken}"
        });
    setState(() {});

    if (response.statusCode == 200) {
      print("got exercises correctly");
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // get_plans_exercises();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddWorkout(),
              maintainState: false,
            ),
          );
        },
        elevation: 2,
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/pxfuel.jpg"),
            //   fit: BoxFit.cover,
            // ),
            color: Color(0xFF1F1F1F)),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: Colors.white.withOpacity(0.25),
            activeColor: Colors.white,
            padding: const EdgeInsets.all(10),
            tabBackgroundColor: Colors.black.withOpacity(0.1),
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.visibility,
              ),
              GButton(
                icon: Icons.signal_cellular_alt,
              ),
              GButton(
                icon: Icons.content_paste,
              ),
              GButton(icon: Icons.person),
            ],
          ),
        ),
      ),
    );
  }
}
