import 'package:companion/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  Future<bool> isLoggedIn() async {
    final url = "http://127.0.0.1:8000/validate/";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      // token is invalid
      // remove from storage as no longer needed
      await prefs.remove('token');
      return false;
    } else {
      // error handling later to be implemented
      return false;
    }
  }

  Future<void> _checkLoggedIn() async {
    bool loggedIn = await isLoggedIn();
    if (!loggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Signed In'));
  }
}
