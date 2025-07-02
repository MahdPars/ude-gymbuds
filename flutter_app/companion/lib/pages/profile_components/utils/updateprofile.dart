import 'package:http/http.dart' as http;
import 'package:companion/pages/profile_components/classes/userprofile_class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void updateUserProfileField(
    String username, String field, dynamic value) async {
  final prefs = await SharedPreferences.getInstance();
  final idToken = prefs.getString('token') ?? '';

  final response = await http.patch(
    Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/update_fields/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $idToken'
    },
    body: jsonEncode(<String, dynamic>{
      field: value,
    }),
  );

  if (response.statusCode == 200) {
    print('Successfully updated $field');
  } else {
    throw Exception('Failed to update $field');
  }
}

void updateUserProfile(UserProfile updatedProfile) async {
  final prefs = await SharedPreferences.getInstance();
  final idToken = prefs.getString('token') ?? '';

  final response = await http.patch(
    Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/update_profile/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $idToken',
    },
    body: jsonEncode(updatedProfile.toJson()),
  );

  if (response.statusCode == 200) {
    print('User profile updated successfully.');
  } else {
    throw Exception('Failed to update user profile.');
  }
}
