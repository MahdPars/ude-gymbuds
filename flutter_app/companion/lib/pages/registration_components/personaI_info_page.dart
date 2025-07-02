import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:companion/pages/registration_components/utils/textfields.dart';
import 'package:companion/pages/registration_components/classes/registrationdata.dart';

class PersonalInfo extends StatefulWidget {
  final RegistrationData registrationData;
  final Function navigateToNextPage;
  final Function naviagteToPreviousPage;

  const PersonalInfo({
    Key? key,
    required this.registrationData,
    required this.navigateToNextPage,
    required this.naviagteToPreviousPage,
  }) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  XFile? _pickedImage;

  Future<void> _uploadImage(XFile imageFile, String username) async {
    var request = http.MultipartRequest('POST',
        Uri.parse('http://${dotenv.env['SERVER_IP']}:8000/upload_image/'));

    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path,
        filename: basename(imageFile.path)));
    request.fields['username'] = username;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded!');
    } else {
      print('Image upload failed!');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _usernameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pxfuel.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Registration',
                style: GoogleFonts.inter(
                  fontSize: 54,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Let\'s get you ready to start! We are gonna need some information to setup your Gymbuddy account.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _pickedImage != null
                              ? FileImage(File(_pickedImage!.path))
                                  as ImageProvider<Object>
                              : AssetImage(
                                  'assets/icons/user_circle_light.png'),
                          fit: BoxFit.cover),
                    ),
                  )),
              SizedBox(
                height: 25,
              ),
              CustomTextField(controller: _nameController, hintText: 'Name'),
              SizedBox(
                height: 10,
              ),
              //username
              CustomTextField(
                  controller: _usernameController, hintText: 'Username'),
              SizedBox(
                height: 10,
              ),
              //registration email
              CustomTextField(controller: _emailController, hintText: 'Email'),
              SizedBox(
                height: 10,
              ),
              //registration password
              CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true),
              SizedBox(
                height: 10,
              ),
              // password confirmation to avoid typos going through during registration
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                isPassword: true,
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button color
                        foregroundColor: Colors.black, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Circular edges
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 10)),
                    onPressed: () {
                      widget.naviagteToPreviousPage();
                    },
                    child: Text(
                      'Back',
                      style: GoogleFonts.raleway(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button color
                        foregroundColor: Colors.black, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Circular edges
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _usernameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _confirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill out all fields!'),
                          ),
                        );
                      } else if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Passwords do not match!'),
                          ),
                        );
                      } else {
                        widget.registrationData.name = _nameController.text;
                        widget.registrationData.username =
                            _usernameController.text;
                        widget.registrationData.email = _emailController.text;
                        widget.registrationData.password =
                            _passwordController.text;
                        widget.registrationData.confirmPassword =
                            _confirmPasswordController.text;
                        _uploadImage(_pickedImage!, _usernameController.text);
                        widget.navigateToNextPage();
                      }
                    },
                    child: Text(
                      'Continue',
                      style: GoogleFonts.raleway(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
