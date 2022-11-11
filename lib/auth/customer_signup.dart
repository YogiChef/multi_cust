import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:hub/providers/auth_repo.dart';
import 'package:image_picker/image_picker.dart';

import '../service/globas_service.dart';
import '../widgets/auth_widget.dart';
import '../widgets/snackbar.dart';
import '../widgets/widget_button.dart';

// final TextEditingController _namecontroller = TextEditingController();
// final TextEditingController _emailcontroller = TextEditingController();
// final TextEditingController _passwordcontroller = TextEditingController();
// final TextEditingController _phonecontroller = TextEditingController();

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  late String name;
  late String email;
  late String password;
  late String phone;
  late String profileImage;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic pickedImageError;

  CollectionReference customers = store.collection('customers');

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      pickedImageError = e;
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      pickedImageError = e;
    }
  }

  bool passwordvisible = true;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextUser(text: 'Customer'),
                    const AuthHeaderLabel(
                      headerLabel: 'Sign Up',
                    ),
                    HaveAccount(
                      haveAccount: 'already have account?',
                      actionLabel: 'Log In',
                      press: () {
                        Navigator.pushReplacementNamed(
                            context, 'customer_login');
                      },
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.deepOrangeAccent,
                            backgroundImage: _imageFile == null
                                ? null
                                : FileImage(File(_imageFile!.path)),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 45,
                              decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _pickImageFromCamera();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 45,
                              decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.photo,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    InputTextforfield(
                      label: 'Full Name',
                      hint: 'Enter your full nmae',
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        name = value!;
                      },
                      // controller: _namecontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your full name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    InputTextforfield(
                      label: 'Email Address',
                      hint: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        email = value!;
                      },
                      // controller: _emailcontroller,
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
                      // controller: _passwordcontroller,
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
                    InputTextforfield(
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        phone = value!;
                      },
                      // controller: _phonecontroller,
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    processing == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.purpleAccent,
                            ),
                          )
                        : TealButton(
                            press: signUp,
                            width: double.infinity,
                            name: 'Sign Up',
                            txtColor: Colors.white,
                            color: Colors.teal,
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          AuthRepo.singUpWithEmailAndPassword(email, password);
          // await auth.createUserWithEmailAndPassword(
          //     email: email, password: password);
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('cust_images/$email.jpg');
          await ref.putFile(File(_imageFile!.path));
          _uid = AuthRepo.uid;
          // _uid = auth.currentUser!.uid;
          profileImage = await ref.getDownloadURL();
          AuthRepo.updateProfileImage(profileImage);
          AuthRepo.updateUserName(name);
          await customers.doc(_uid).set({
            'name': name,
            'email': email,
            'profileImage': profileImage,
            'phone': phone,
            'address': '',
            'cid': _uid,
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
          await Future.delayed(const Duration(microseconds: 100)).whenComplete(
              () => Navigator.pushReplacementNamed(context, 'onboarding_page'));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The account already exists for that email.');
          }
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'please pick your image first');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          content: Text(
            'pleas fill all fields',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
          )));
    }
  }
}
