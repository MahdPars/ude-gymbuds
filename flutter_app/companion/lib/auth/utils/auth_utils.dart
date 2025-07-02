import 'package:companion/pages/registration_components/classes/registrationdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future<void> singUp(RegistrationData data) async {
  final url = "http://${dotenv.env['SERVER_IP']}:8000/create_user/";

  final body = {
    if (data.email != null) "email": data.email!,
    if (data.password != null) "password": data.password!,
    if (data.confirmPassword != null) "password_conf": data.confirmPassword!,
    if (data.name != null) "name": data.name!,
    if (data.username != null) "username": data.username!,
    if (data.bodyType != null) "bodyType": data.bodyType!,
    if (data.age != null) "age": data.age!,
    if (data.height != null) "height": data.height!,
    if (data.weight != null) "weight": data.weight!,
    if (data.experience != null) "experience": data.experience!,
    if (data.goal != null) "goal": data.goal!,
    if (data.frequency != null) "frequency": data.frequency!,
    if (data.painPoints != null) "painPoints": data.painPoints!,
  };
  //sending the request
  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  //handling response codes
  if (response.statusCode == 200) {
    // response contains {'message':'', 'token':'', 'status':''}
    // token is then used to continually authenticate Users Session
    // tokens lose validity after one hour
  } else {
    print("Error with Status Code: ${response.statusCode}");
  }
  //updating UI
}

Future<bool> isLoggedIn() async {
  final url = "http://${dotenv.env['SERVER_IP']}:8000/validate/";
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
