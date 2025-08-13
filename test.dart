import 'dart:typed_data';
import 'package:delta_mobile_app/dsms/words.dart';
import 'package:delta_mobile_app/dsms/wordsEn.dart';
 import 'package:characters/characters.dart';
//import 'package:delta_mobile_app/util.dart' as util;
//import 'package:flutter/material.dart';
import 'package:archive/archive.dart';
import 'dart:io' as io;


void main() async {
  
    String text = "MY70ONWTTijek7XNE6uYMmBgmXPQP5Xr03ZTO5ZTS%2B4w%2BzzlxtlWPLxt8M1mN%2FwZ";
    text = Uri.decodeComponent(text);
    print(text.characters);
    print(text.characters.length);

  //   print(bytes.length);
  //   final dsmsWords = DSMSwords.fromBytes(bytes, EncodeLang.en);
  //   print("dsmsWords");
  //   print(dsmsWords);
  //   final url =  buildVerifyStringUri("8618402010506", dsmsWords);
  //   // //print("length: ${dsmsWords.characters.length}");
  //   print(url);
  //   final bytess = DSMSwords.toBytes(dsmsWords, EncodeLang.en);
  //   print(bytess);
}

//
