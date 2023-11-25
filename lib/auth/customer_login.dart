// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hub/auth/forgot_pass.dart';
import 'package:hub/main_page/welcom.dart';
import 'package:hub/providers/auth_repo.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:provider/provider.dart';
import '../service/global_service.dart';
import '../widgets/auth_widget.dart';
import '../widgets/snackbar.dart';
import '../widgets/widget_button.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin>
    with SingleTickerProviderStateMixin {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  CollectionReference customers = store.collection('customers');

  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool passwordvisible = true;
  bool sendEmailveridication = false;

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await customers.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  setUserId(User user) {
    context.read<IdProvider>().setCustId(user);
  }

  bool docExists = false;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await auth.signInWithCredential(credential).whenComplete(() async {
      User user = auth.currentUser!;
      print(googleUser!.id);
      print(auth.currentUser!.uid);
      print(googleUser);
      print(user);
      setUserId(user);
      // final SharedPreferences pref = await _prefs;
      // pref.setString('custId', user.uid);

      // print(user.uid);

      docExists = await checkIfDocExists(user.uid);
      docExists == false
          ? await customers.doc(user.uid).set({
              'name': googleUser.displayName,
              'email': googleUser.email,
              'profileImage': googleUser.photoUrl,
              'phone': '',
              'address': '',
              'cid': user.uid,
            }).then((value) => navigate())
          : navigate();
    });
  }

  navigate() {
    Navigator.pushReplacementNamed(context, 'onboarding_page');
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            // reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextUser(
                      text: 'Customer',
                    ),
                    const AuthHeaderLabel(
                      headerLabel: 'Log In',
                    ),
                    HaveAccount(
                      haveAccount: 'Don\'t have account? ',
                      actionLabel: 'Sign Up',
                      press: () {
                        Navigator.pushReplacementNamed(
                            context, 'customer_signup');
                      },
                    ),
                    SizedBox(
                      height: 50,
                      child: sendEmailveridication == true
                          ? Center(
                              child: TealButton(
                                width: 0.7,
                                name: 'Resend Email verification',
                                color: Colors.grey.shade100,
                                press: () async {
                                  try {
                                    auth.currentUser!.sendEmailVerification();
                                  } catch (e) {
                                    (e);
                                  }
                                  Future.delayed(const Duration(seconds: 3))
                                      .whenComplete(() {
                                    setState(() {
                                      sendEmailveridication = false;
                                    });
                                  });
                                },
                              ),
                            )
                          : const SizedBox(),
                    ),
                    InputTextforfield(
                      label: 'Email Address',
                      hint: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        email = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email addres';
                        } else if (value.isValidEmail() == false) {
                          return 'invalid email';
                        } else if (value.isValidEmail() == true) {
                          return null;
                          // MyMessageHandler.showSnackBar(
                          //     _scaffoldKey, 'your email is valid');
                        } else {
                          return null;
                        }
                      },
                    ),
                    InputTextforfield(
                      obscureText: passwordvisible,
                      label: 'Password',
                      hint: 'Enter your password',
                      onSaved: (value) {
                        password = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordvisible = !passwordvisible;
                            });
                          },
                          icon: Icon(
                            passwordvisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.teal,
                          )),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword()));
                        },
                        child: Text(
                          'Forget Password',
                          style: GoogleFonts.acme(
                              color: Colors.teal,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                        )),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    processing == true
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.purpleAccent,
                          ))
                        : TealButton(
                            press: logIn,
                            width: double.infinity,
                            name: 'Log In',
                            txtColor: Colors.white,
                            color: Colors.teal,
                          ),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: GoogleFacebookLogin(
                        label: 'Google',
                        child: const Image(
                            image: AssetImage('images/inapp/google.jpg')),
                        press: () {
                          signInWithGoogle();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void logIn() async {
   
    if (_formKey.currentState!.validate()) {
      setState(() {
        processing = true;
      });
      try {
        await AuthRepo.loginWithEmailAndPassword(email, password);
        await AuthRepo.reloadUserData();

        if (await AuthRepo.checkEmailVerification()) {
          _formKey.currentState!.reset();

          User user = auth.currentUser!;
          setUserId(user);
          // final SharedPreferences pref = await _prefs;
          // pref.setString('custId', user.uid);

          // print(user.uid);
          await Future.delayed(const Duration(microseconds: 100)).whenComplete(
              () => Navigator.pushReplacementNamed(context, 'onboarding_page'));
        } else {
          MyMessageHandler.showSnackBar(_scaffoldKey, 'pleas check your email');
          setState(() {
            processing = false;
            sendEmailveridication = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        if (e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
          //   } else if (e.code == 'wrong-password') {
          // setState(() {
          //   processing = false;
          // });
          //     MyMessageHandler.showSnackBar(
          //         _scaffoldKey, 'Wrong password provided for that user.');
          //   }
          // }
        } else {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
        }
      }
    }
  }
}
