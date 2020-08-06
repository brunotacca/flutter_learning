import 'package:biometric_storage/biometric_storage.dart';
import 'package:crypton/crypton.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:safe_storage_biometric_encryption/welcome_screen.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class FringerPrintScreen extends StatefulWidget {
  @override
  _FringerPrintScreenState createState() => _FringerPrintScreenState();
}

class _FringerPrintScreenState extends State<FringerPrintScreen> {
  BiometricStorageFile storageFile;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, String> _actualDeviceData = <String, String>{};
  String _actualDeviceFingerprint = "";
  final TextEditingController _writeController =
      TextEditingController(text: '');
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _newUser = true;
  String _customMessage = "";
  Color __customMessageColor = Colors.blueAccent;
  String _rsaPublic;

  @override
  void initState() {
    super.initState();

    _initStorageSecurityControl();
    _checkAuthenticate();
  }

  Future<bool> _authenticate(dynamic resultJson) async {
    if (resultJson['rsaPublic'] != _rsaPublic) {
      await storageFile.delete();
      return false;
    }

    RSAPrivateKey priv = RSAPrivateKey.fromString(resultJson['rsaPrivate']);

    String dfp = priv.decrypt(resultJson['deviceFingerprint']);
    if (dfp != _actualDeviceFingerprint) {
      await storageFile.delete();
      return false;
    }

    String smth = priv.decrypt(resultJson['something']);
    if (smth != _writeController.text) {
      return false;
    }

    print("WELCOME BACK!");

    return true;
  }

  Future<Map<String, String>> _generateNewUserData() async {
    Map<String, String> newUserData = <String, String>{};

    var rsaKeypair = RSAKeypair.fromRandom();
    newUserData['rsaPrivate'] = rsaKeypair.privateKey.toString();
    newUserData['rsaPublic'] = rsaKeypair.publicKey.toString();
    newUserData['deviceFingerprint'] =
        rsaKeypair.publicKey.encrypt(_actualDeviceFingerprint);
    newUserData['something'] =
        rsaKeypair.publicKey.encrypt(_writeController.text);

    final SharedPreferences prefs = await _prefs;
    await prefs.setString('rsaPublic', newUserData['rsaPublic']);
    _rsaPublic = prefs.getString("rsaPublic");

    return newUserData;
  }

  Future<void> _initStorageSecurityControl() async {
    final SharedPreferences prefs = await _prefs;

    // Check for Existing RSA Public Key
    _rsaPublic = prefs.getString("rsaPublic");
    bool newbie = true;
    if (_rsaPublic != null && _rsaPublic.length > 0) {
      newbie = false;
    }

    // Get device info
    _actualDeviceData = await _initPlatformState();
    _actualDeviceFingerprint = _actualDeviceData.values.join();

    if (!mounted) return;
    setState(() {
      _newUser = newbie;
    });

    /*
    print("_deviceFingerprint: $_deviceFingerprint");
    String _deviceFingerprint32b =
        _deviceFingerprint.substring(_deviceFingerprint.length - 10);
    print("_deviceFingerprint32b: $_deviceFingerprint32b");
    final b64key = encr.Key.fromUtf8(
        base64Url.encode(encr.Key.fromUtf8(_deviceFingerprint32b).bytes));
    print("b64key ${b64key.base64}");
    final fernet = encr.Fernet(b64key);
    _encrypter = encr.Encrypter(fernet);
    encr.Encrypted encrypted = _encrypter.encrypt("HELLO WORLD");
    print("HELLO WORLD ENCRYPTED: " + encrypted.base64);
    print("HELLO WORLD DECRYPTED: " + _encrypter.decrypt(encrypted));
    */
    /*
    var rsaKeypair = RSAKeypair.fromRandom();
    var message = "Hello World!";

    var privateKeyString = rsaKeypair.privateKey.toString();
    var publicKeyString = rsaKeypair.publicKey.toString();
    var encrypted = rsaKeypair.publicKey.encrypt(message);
    var decrypted = rsaKeypair.privateKey.decrypt(encrypted);

    print('Your Private Key\n $privateKeyString\n---');
    print('Your Public Key\n $publicKeyString\n---');
    print('Encrypted Message\n $encrypted\n---');
    print('Decrypted Message\n $decrypted\n---');

    if (decrypted == message) {
      print('The Message was successfully decrypted!');
    } else {
      print('Failed to decrypted the Message!');
    }
    */
  }

  Future<Map<String, String>> _initPlatformState() async {
    Map<String, String> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, String>{
        'Error:': 'Failed to get platform version.'
      };
    }

    return deviceData;
  }

  Map<String, String> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, String>{
      'board': build.board,
      'device': build.device,
      'fingerprint': build.fingerprint,
      'androidId': build.androidId,
    };
  }

  Map<String, String> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, String>{
      'systemName': data.systemName,
      'model': data.model,
      'identifierForVendor': data.identifierForVendor,
    };
  }

  Future<CanAuthenticateResponse> _checkAuthenticate() async {
    final response = await BiometricStorage().canAuthenticate();
    print('checked if authentication was possible: $response');

    return Future.delayed(
      Duration(seconds: 2),
      () async {
        if (response != CanAuthenticateResponse.success) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()));
          return null;
        } else {
          storageFile = await BiometricStorage().getStorage(
            'biometricStorageFile',
            options: StorageFileInitOptions(
                authenticationValidityDurationSeconds: 60),
            androidPromptInfo: const AndroidPromptInfo(
              title: 'YOU',
              subtitle: 'SHALL NOT',
              description: 'PASS!',
              negativeButton: 'Okey!',
            ),
          );
          return response;
        }
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
                _newUser ? "There is nothing here." : "Welcome back!",
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
                      child: Hero(
                        tag: 'lock',
                        child: IconButton(
                          icon: Icon(
                            Icons.lock,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                          onPressed: () async {
                            print("UNLOCK");
                            if (_writeController.text != null &&
                                _writeController.text.isNotEmpty) {
                              try {
                                final result = await storageFile.read();
                                final resultJson =
                                    result != null ? json.decode(result) : null;

                                if (result == null ||
                                    resultJson == null ||
                                    resultJson['deviceFingerprint'] == null) {
                                  Map<String, String> data =
                                      await _generateNewUserData();
                                  await storageFile.write(json.encode(data));

                                  setState(() {
                                    _writeController.text = "";
                                    _customMessage =
                                        "Welcome New User!\nType your something and authenticate again!";
                                    __customMessageColor = Colors.greenAccent;
                                  });

                                  print("FIRST ENTRY! WRITED!");
                                } else {
                                  final SharedPreferences prefs = await _prefs;
                                  if (_rsaPublic == null)
                                    await _initStorageSecurityControl();

                                  bool a = await _authenticate(resultJson);

                                  if (!a) {
                                    _writeController.text = "";
                                    _customMessage = "¯\\_(ツ)_/¯";
                                    __customMessageColor = Colors.red;
                                  } else {
                                    _writeController.text = "( ͡° ͜ʖ ͡°)";
                                    _customMessage = "YOU MAY ENTER...";
                                    __customMessageColor = Colors.greenAccent;
                                    Future.delayed(Duration(seconds: 2), () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WelcomeScreen()));
                                    });
                                  }

                                  setState(() {});

                                  print("WELCOME BACK! $a");
                                }
                              } catch (e) {
                                print("Error: $e");
                                setState(() {
                                  _writeController.text = "";
                                });
                              }
                            }
                          },
                        ),
                      ),
                    );
                },
              ),
              Divider(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      ">",
                      style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          color: Colors.blueAccent),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Tell me something',
                      ),
                      style: TextStyle(color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                      controller: _writeController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "<",
                      style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
              _customMessage.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _customMessage,
                        style: TextStyle(color: __customMessageColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
              Divider(),
              RaisedButton(
                child: Text("Wipe Storage"),
                onPressed: () async {
                  await storageFile.delete();
                  final SharedPreferences prefs = await _prefs;
                  prefs.setString("rsaPublic", "");
                  print("DELETED");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
