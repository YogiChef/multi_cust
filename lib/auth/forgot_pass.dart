import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/providers/auth_repo.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:hub/widgets/auth_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String resetPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const AppbarTitle(title: 'Forgot Password ?'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 170,
                      child: Image.asset('images/inapp/shopshub.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'to reset your email password',
                        style: GoogleFonts.acme(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextforfield(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your email ';
                          } else if (!value.isValidEmail()) {
                            return 'invalid email';
                          } else if (value.isValidEmail()) {
                            return null;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          resetPass = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email Address',
                        hint: 'enter your email'),
                    const SizedBox(
                      height: 40,
                    ),
                    MaterialButton(
                      color: Colors.teal,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          AuthRepo.sendPasswordResetEmail(resetPass)
                              .whenComplete(() => Navigator.pop(context));
                        } else {
                          ('form not valid');
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: const Text(
                        'Send Reset Password',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
