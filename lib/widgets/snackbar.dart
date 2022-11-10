import 'package:flutter/material.dart';

class MyMessageHandler {
  static void showSnackBar(var scaffoldKey, String message) {
    scaffoldKey.currentState!.showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.deepOrange.withOpacity(0.7),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        )));
  }
}
