// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/service/globas_service.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/appbar_widgets.dart';
import '../widgets/snackbar.dart';
import '../widgets/widget_button.dart';

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({Key? key, required this.data}) : super(key: key);

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final ImagePicker _picker = ImagePicker();
  XFile? imageFileLogo;
  XFile? imageFileCover;
  dynamic pickedimageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          title: const AppbarTitle(title: 'edit store'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      'Stor Logo',
                      style: GoogleFonts.acme(
                        fontSize: 24,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.data['storelogo']),
                        ),
                        Column(
                          children: [
                            imageFileLogo == null
                                ? TealButton(
                                    width: 0.3,
                                    name: 'Change',
                                    txtColor: Colors.white,
                                    press: () {
                                      pickStoreLogo();
                                    },
                                  )
                                : TealButton(
                                    width: 0.3,
                                    name: 'Reset',
                                    txtColor: Colors.white,
                                    color: Colors.teal,
                                    press: () {
                                      setState(() {
                                        imageFileLogo = null;
                                      });
                                    },
                                  ),
                          ],
                        ),
                        imageFileLogo == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(imageFileLogo!.path)),
                              ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Cover image',
                      style: GoogleFonts.acme(
                        fontSize: 24,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.data['coverimage']),
                        ),
                        Column(
                          children: [
                            imageFileCover == null
                                ? TealButton(
                                    width: 0.3,
                                    name: 'Change',
                                    txtColor: Colors.white,
                                    press: () {
                                      pickCoverimage();
                                    },
                                  )
                                : TealButton(
                                    width: 0.3,
                                    name: 'Reset',
                                    txtColor: Colors.white,
                                    color: Colors.teal,
                                    press: () {
                                      setState(() {
                                        imageFileCover = null;
                                      });
                                    },
                                  ),
                          ],
                        ),
                        imageFileCover == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(imageFileCover!.path)),
                              ),
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Divider(
                    thickness: 2,
                    color: Colors.teal,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'plaese enter store name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      storeName = value!;
                    },
                    initialValue: widget.data['storename'],
                    decoration: textDecoration.copyWith(
                        labelText: 'store name', hintText: 'Enter Store name'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'plaese enter phone';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textDecoration.copyWith(
                        labelText: 'phone',
                        hintText: 'Enter your phone number'),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TealButton(
                        width: 0.25,
                        name: 'Cancel',
                        txtColor: Colors.white,
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                      processing == true
                          ? TealButton(
                              width: 0.35,
                              name: 'please wait..',
                              txtColor: Colors.white,
                              press: () {},
                            )
                          : TealButton(
                              width: 0.35,
                              name: 'Save Changes',
                              txtColor: Colors.white,
                              press: () {
                                saveChanges();
                              },
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileLogo = pickedStoreLogo;
      });
    } catch (e) {
      pickedimageError = e;
    }
  }

  pickCoverimage() async {
    try {
      final pickedCoverimg = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileCover = pickedCoverimg;
      });
    } catch (e) {
      pickedimageError = e;
    }
  }

  void saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(() async =>
          await uploadCoverImage().whenComplete(() => editStoredata()));
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'plaese fill all fields');
    }
  }

  Future uploadStoreLogo() async {
    if (imageFileLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp_images/${widget.data['email']}.jpg');

        await ref.putFile(File(imageFileLogo!.path));

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageFileCover != null) {
      try {
        firebase_storage.Reference rf = firebase_storage
            .FirebaseStorage.instance
            .ref('supp_images/${widget.data['email']}.jpg-cover');

        await rf.putFile(File(imageFileCover!.path));

        coverImage = await rf.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  Future editStoredata() async {
    await store.runTransaction((transaction) async {
      DocumentReference dRf =
          store.collection('suppliers').doc(auth.currentUser!.uid);
      transaction.update(dRf, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': coverImage,
      });
    });
    await Future.delayed(const Duration(microseconds: 100))
        .whenComplete(() => Navigator.pop(context));
  }
}

var textDecoration = const InputDecoration(
    labelText: 'price',
    hintText: 'price .. ฿',
    labelStyle: TextStyle(
      color: Colors.teal,
    ),
    contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepOrange, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepOrange, width: 2),
    ));
