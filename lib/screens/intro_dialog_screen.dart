import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
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
      backgroundColor: backgroundColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to the App',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'This app helps you manage your tasks efficiently.',
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
                        'Add and Complete Tasks',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Swipe right to complete a task or left to delete it.',
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isFirstTime', false);
                          await Navigator.of(context)
                              .pushReplacementNamed('/home');
                        },
                        child: Text('Start'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
