import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
import 'package:beforesunsetai_mobile_case_study/constant/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TermsOfUseScreen extends StatefulWidget {
  @override
  _TermsOfUseScreenState createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Terms of Use'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "The Terms of Use outline the rules and regulations for the use of this application. By accessing and using this application, you accept and agree to be bound by these terms. All data is stored locally on your device and inaccessible to us.",
            textAlign: TextAlign.center,
            style: fontStyle(20, Colors.black, FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
