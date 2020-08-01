import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:safe_storage_biometric_encryption/welcome_screen.dart';

class FringerPrintScreen extends StatefulWidget {
  @override
  _FringerPrintScreenState createState() => _FringerPrintScreenState();
}

class _FringerPrintScreenState extends State<FringerPrintScreen> {
  BiometricStorageFile _customPrompt;

  @override
  void initState() {
    super.initState();

    _checkAuthenticate();
  }

  Future<CanAuthenticateResponse> _checkAuthenticate() async {
    final response = await BiometricStorage().canAuthenticate();
    print('checked if authentication was possible: $response');

    return Future.delayed(
      Duration(seconds: 2),
      () {
        if (response == CanAuthenticateResponse.success) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()));
          return null;
        } else
          return response;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "There is nothing here.",
                style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    color: Colors.blueAccent),
              ),
              FutureBuilder<CanAuthenticateResponse>(
                future: _checkAuthenticate(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Column(
                      children: [
                        Divider(),
                        CircularProgressIndicator(),
                      ],
                    );
                  } else
                    return SizedBox(
                      child: IconButton(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                        onPressed: () {
                          print("UNLOCK");
                        },
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
