import 'package:flutter/material.dart';
import 'package:safe_storage_biometric_encryption/yeti.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          YetiPinScreen(),
          Positioned(
            top: MediaQuery.of(context).size.center(Offset.zero).dy + 57,
            child: InkWell(
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
              onTap: () {
                print("Q");
              },
            ),
          ),
        ],
      ),
    );
  }
}
