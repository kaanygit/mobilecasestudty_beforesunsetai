import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
import 'package:beforesunsetai_mobile_case_study/constant/fonts.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroDialog extends StatefulWidget {
  const IntroDialog({Key? key}) : super(key: key);

  @override
  _IntroDialogState createState() => _IntroDialogState();
}

class _IntroDialogState extends State<IntroDialog> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (!isFirstTime) {
      Navigator.of(context).pushReplacementNamed('/home');
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor3,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child:Image.asset("assets/images/avatar.jpg",width:200,height: 200,)),
                      SizedBox(height: 20,),
                      Text(
                        'Welcome to the App',
                        style: fontStyle(24, Colors.black, FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'This app helps you manage your tasks efficiently.',
                        style: fontStyle(13, Colors.black, FontWeight.normal),

                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child:Image.asset("assets/images/avatar.jpg",width:200,height: 200,)),
                      SizedBox(height: 20,),
                      Text(
                        'Add and Complete Tasks',
                        style: fontStyle(24, Colors.black, FontWeight.bold),

                      ),
                      SizedBox(height: 20),
                      Text(
                        'Swipe right to complete a task or left to delete it.',
                                                style: fontStyle(13, Colors.black, FontWeight.normal),

                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started Now',
                          style: fontStyle(24, Colors.black, FontWeight.bold),

                      ),
                      SizedBox(height: 20),
                      Spacer(),
                      MyButton(text: "Start", buttonColor: buttonColor, buttonTextColor: Colors.white, buttonTextSize: 20, buttonTextWeight: FontWeight.bold, onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isFirstTime', false);
                          await Navigator.of(context)
                              .pushReplacementNamed('/home');
                        }, buttonWidth: ButtonWidth.large,borderRadius: BorderRadius.circular(16),),
                      
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
