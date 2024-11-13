import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen/HomeScreen.dart';
import 'Onboarding/UI/OnboardingScreen.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: FutureBuilder<bool>(
            future: _checkFirstSeen(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return HomeScreen();
                } else {
                  return OnboardingScreen();
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return HomeScreen();
            } else {
              return OnboardingScreen();
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
Future<bool> _checkFirstSeen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _seen = (prefs.getBool('seen') ?? false);

  if (!_seen) {
    await prefs.setBool('seen', true);
  }

  return _seen;
}