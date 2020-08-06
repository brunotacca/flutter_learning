import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:safe_storage_biometric_encryption/yeti.dart';
import 'package:flutter/scheduler.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  final TextEditingController _writeController =
      TextEditingController(text: '');

  bool isAuthenticated = false;

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 3.0;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          YetiPinScreen(),
          Positioned(
            top: MediaQuery.of(context).size.center(Offset.zero).dy + 57,
            child: InkWell(
              onTap: () {
                _showLockScreen(
                  context,
                  opaque: false,
                  circleUIConfig: CircleUIConfig(
                      borderColor: Colors.blue,
                      fillColor: Colors.blue,
                      circleSize: 30),
                  keyboardUIConfig: KeyboardUIConfig(
                      digitBorderWidth: 2, primaryColor: Colors.blue),
                  cancelButton: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                  digits: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '❤']
                    ..shuffle(),
                );
              },
              child: Hero(
                tag: 'lock',
                child: ClipOval(
                  child: Container(
                    color: Color(0xFF60C7D0),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.center(Offset.zero).dy + 180,
            child: Text("There might be something hidden here..."),
          ),
          isAuthenticated
              ? Container()
              : Positioned(
                  top: MediaQuery.of(context).size.center(Offset.zero).dy + 210,
                  child: Row(
                    children: [
                      Text(">"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(),
                      ),
                      Text("<"),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig,
      Widget cancelButton,
      List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'Secret PIN',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '12345❤' == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
