import 'package:flutter/cupertino.dart';

String parseLimitStr(int i) {
  switch(i) {
    case 0: return '禁止';
    case 1: return '限制';
    default: return '准限';
  }
}
Color parseLimitColor(int i) {
  switch(i) {
    case 0: return Color.fromARGB(255, 255, 0, 0);
    case 1: return Color.fromARGB(255, 255, 127, 0);
    default: return Color.fromARGB(255, 0, 255, 0);
  }
}

Color parseLimitBlock(String c) => Color(int.parse('FF' + c.replaceAll('#', ''), radix: 16));

String parseName(String n) => n == null ? '-' : n;
String parseImage(String n) => n == null ? '0' : n;