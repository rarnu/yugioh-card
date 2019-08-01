import 'package:flutter/cupertino.dart';

SizedBox sized(Widget child, {double width = double.infinity, double height = double.infinity}) => SizedBox(width: width, height: height, child: child);
SizedBox sizedw(Widget child, {double width = double.infinity}) => SizedBox(width: width, child: child);
SizedBox sizedh(Widget child, {double height = double.infinity}) => SizedBox(height: height, child: child);
Expanded expend(Widget child, {int flex = 1}) => Expanded(child: child, flex: flex);
Container colorBlock(Color color, {double width, double height, double marginTop = 0, double marginLeft = 0, double marginRight = 0, double marginBottom = 0}) => Container(margin: EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom), width: width, height: height, color: color);