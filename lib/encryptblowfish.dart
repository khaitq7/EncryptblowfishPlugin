import 'dart:async';

import 'package:flutter/services.dart';

class Encryptblowfish {
  static const MethodChannel _channel =
  const MethodChannel('encryptblowfish');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getStringAfterEncrypt(String key , String originStr) async{
    String str;
    try{
      str = await _channel.invokeMethod('getStringAfterEncrypt' , <String , dynamic> {
        'key' : key,
        'origin': originStr
      });
    }catch(e){
      print(e);
      str = 'Unknown';
    }
    return str;
  }

  static Future<String> getStringAfterDecrypt(String key , String decryptStr) async{
    String str;
    try{
      str = await _channel.invokeMethod('getStringAfterDecrypt' , <String , dynamic> {
        'key' : key,
        'decrypt': decryptStr
      });
    }catch(e){
      print(e);
      str = 'Unknown';
    }
    return str;
  }
}
