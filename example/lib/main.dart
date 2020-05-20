import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:encryptblowfish/encryptblowfish.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String key = 'abc';
  String originStr = 'abcxyz';//todo chuỗi gốc , đang chưa mã hóa
  String decryptStr = 'kIk42UnwY8g=';//todo chuỗi đã được mã hóa , cần được giải hóa
  String _encrypt = 'Unknown';
  String _decrypt = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String encrypt;
    String decrypt;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Encryptblowfish.platformVersion;
      encrypt = await Encryptblowfish.getStringAfterEncrypt(key, originStr);
      decrypt = await Encryptblowfish.getStringAfterDecrypt(key, decryptStr);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _encrypt = encrypt;
      _decrypt = decrypt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Center(
              child: Text("Encrypt : $_encrypt"),
            ),
            Center(
              child: Text("Decrypt : $_decrypt"),
            )
          ],
        ),
      ),
    );
  }
}
