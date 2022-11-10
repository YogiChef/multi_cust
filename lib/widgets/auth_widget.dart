// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputTextforfield extends StatelessWidget {
  final String? initialValue;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final String? errorText;
  InputTextforfield({
    Key? key,
    this.initialValue,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.maxLength,
    this.controller,
    this.onSaved,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: TextFormField(
        initialValue: initialValue,
        maxLength: maxLength,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onSaved,
        decoration: textFormDecoration.copyWith(
          labelText: label,
          hintText: hint,
          suffixIcon: suffixIcon,
          errorText: errorText,
        ),
      ),
    );
  }

  InputDecoration textFormDecoration = InputDecoration(

      // floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.teal, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(10)));
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() press;
  const HaveAccount({
    Key? key,
    required this.haveAccount,
    required this.actionLabel,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(haveAccount,
            style: GoogleFonts.acme(fontSize: 16, fontStyle: FontStyle.italic)),
        TextButton(
            onPressed: press,
            child: Text(
              actionLabel,
              style: GoogleFonts.acme(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ))
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const AuthHeaderLabel({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          headerLabel,
          style: GoogleFonts.sriracha(
              fontSize: 30, fontWeight: FontWeight.w600, color: Colors.teal),
        ),
        IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'welcome_page');
            },
            icon: const Icon(
              Icons.home_work,
              size: 30,
              color: Colors.teal,
            ))
      ],
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z0-9]{2,3})$')
        .hasMatch(this);
  }
}

class TextUser extends StatelessWidget {
  final String text;
  const TextUser({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.acme(
          color: Colors.deepOrange, fontSize: 40, fontWeight: FontWeight.bold),
    );
  }
}
