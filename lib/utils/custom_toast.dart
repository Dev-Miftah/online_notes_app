import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void show({
    required String message,
    Color backgroundColor = Colors.green,
    double fontSize = 14.0,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast toastLength = Toast.LENGTH_SHORT,
    Color textColor = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      gravity: gravity,
      toastLength: toastLength,
    );
  }
}