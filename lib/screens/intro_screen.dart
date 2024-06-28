import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
import 'package:beforesunsetai_mobile_case_study/constant/fonts.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/buttons.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/flask_message.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  bool _isLoading = true;
  bool _isFirstScreen = true;

  @override
  void initState() {
    super.initState();
    _checkIfUserAlreadyLoggedIn();
  }

  void _checkIfUserAlreadyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final imagePath = prefs.getString('userImage');

    if (username != null && imagePath != null) {
      _navigateToHome();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/intro_dialog');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    if (_image != null) {
      await prefs.setString('userImage', _image!.path);
    }
    showSuccessSnackBar(context,
        "Your picture and name have been successfully saved. Welcome to us.");
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isFirstScreen
              ? _buildFirstScreen()
              : _buildSecondScreen(),
    );
  }

  Widget _buildFirstScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "assets/images/Saly-191.png",
                width: 400,
                height: 400,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Daily Task List',
              style: fontStyle(24, Colors.black, FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Organise all your to-do’s andlist your projects. Color tag them to set priority and categories',
              style: fontStyle(18, Colors.black, FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            MyButton(
                text: "Get Started",
                buttonColor: Colors.black,
                buttonTextColor: Colors.white,
                buttonTextSize: 20,
                buttonTextWeight: FontWeight.normal,
                onPressed: () {
                  setState(() {
                    _isFirstScreen = false;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                buttonWidth: ButtonWidth.xLarge)
          ],
        ),
      ),
    );
  }

  Widget _buildSecondScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage("assets/images/avatar.jpg") as ImageProvider,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Text(
                    'Tap to select an image',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: _usernameController,
                  hintText: "Username",
                  obscureText: false,
                  keyboardType: TextInputType.multiline,
                  enabled: true,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MyButton(
                text: "Save",
                buttonColor: Colors.black,
                buttonTextColor: Colors.white,
                buttonTextSize: 20,
                buttonTextWeight: FontWeight.normal,
                onPressed: () {
                  if (_usernameController.text.isNotEmpty && _image != null) {
                    _saveUserInfo();
                  } else {
                    showErrorSnackBar(context,
                        "Please enter a username and select an image.");
                  }
                },
                borderRadius: BorderRadius.circular(16),
                buttonWidth: ButtonWidth.xxLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
