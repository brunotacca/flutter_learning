import 'package:flutter/material.dart';

import 'countdown_timer.dart';

// Example tutorial found at: https://medium.com/flutterdevs/creating-a-countdown-timer-using-animation-in-flutter-2d56d4f3f5f1
// Added some customizations and a linear timer

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer Example',
      home: CountDownTimer(),
    );
  }
}
