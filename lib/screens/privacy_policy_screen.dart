import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
import 'package:beforesunsetai_mobile_case_study/constant/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Text('Privacy Policy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: backgroundColor3,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "The Privacy Policy explains how your personal data is collected, used, and protected within this application. We do not collect or store any personal data externally; all data is stored locally on your device.",
            textAlign: TextAlign.center,
            style: fontStyle(20, Colors.black, FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
