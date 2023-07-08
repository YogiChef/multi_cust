// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import '../service/global_service.dart';
import '../utilities/categ_list.dart';
import '../widgets/snackbar.dart';
import 'package:path/path.dart' as path;

class UploadProduct extends StatefulWidget {
  const UploadProduct({super.key});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
  late String proId;
  late int? discount = 0;
  bool processing = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? imgFileList = [];
  List<String> imgUrlList = [];

  dynamic pickedImageError;

  String mainCategValue = 'select category';
  String subCtegValue = 'subcategory';

  List<String> subCategList = [];

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imgFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
      print(pickedImageError);
    }
  }

  Widget previewImages() {
    if (imgFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imgFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(
              File(imgFileList![index].path),
              fit: BoxFit.cover,
            );
          });
    } else {
      return const Center(
        child: Text('you have not\n\npicked images yet !'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            color: Colors.blueGrey.shade100,
                            height: size.width * 0.5,
                            width: size.width * 0.5,
                            child: imgFileList != null
                                ? previewImages()
                                : const Center(
                                    child: Text(
                                      'you have not \n \n picked images yet !',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                          ),
                          imgFileList!.isEmpty
                              ? const SizedBox()
                              : Positioned(
                                  top: 10,
                                  left: 10,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueGrey.shade100,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            imgFileList = [];
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                        )),
                                  ),
                                )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'select main category',
                              style: GoogleFonts.acme(
                                  color: Colors.teal, fontSize: 18),
                            ),
                            DropdownButton(
                                icon: const Icon(Icons.expand_more),
                                value: mainCategValue,
                                items: maincateg
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  selectedMainCateg(value);
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'select subcategory',
                              style: GoogleFonts.acme(
                                  color: Colors.teal, fontSize: 18),
                            ),
                            DropdownButton(
                                menuMaxHeight: 500,
                                icon: const Icon(Icons.expand_more),
                                disabledHint: const Text(
                                  'select category',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                value: subCtegValue,
                                items: subCategList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  print(value);
                                  setState(() {
                                    subCtegValue = value!;
                                  });
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.teal,
                    thickness: 1.5,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: size.width * 0.4,
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter product price';
                                } else if (value.isValidPrice() != true) {
                                  return 'not valid quantity';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                price = double.parse(value!);
                              },
                              decoration: textFormDecoration.copyWith(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                labelText: 'price',
                                hintText: 'price .. \$',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: size.width * 0.4,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              } else if (value.isValidDiscount() != true) {
                                return 'not valid discount';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              discount = int.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormDecoration.copyWith(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              labelText: 'discount',
                              hintText: 'discount .. %',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width * 0.45,
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product quantity';
                            } else if (value.isValidQuantity() != true) {
                              return 'invalid price';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          decoration: textFormDecoration.copyWith(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            labelText: 'Quantity',
                            hintText: 'Add Quantity',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width,
                      child: TextFormField(
                          maxLength: 100,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product name';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            proName = value!;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'product name',
                            hintText: 'product name',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width,
                      child: TextFormField(
                          maxLines: 5,
                          maxLength: 500,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product description';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            proDesc = value!;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'product description',
                            hintText: 'product description',
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imgFileList!.isEmpty
                    ? pickProductImages
                    : () {
                        setState(() {
                          imgFileList = [];
                        });
                      },
                backgroundColor: Colors.deepOrange,
                child: imgFileList!.isEmpty
                    ? const Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.white,
                      ),
              ),
            ),
            FloatingActionButton(
              onPressed: processing == true ? null : uploadProduct,
              backgroundColor: Colors.deepOrange,
              child: processing == true
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.upload_outlined,
                      color: Colors.white,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> uploadImages() async {
    if (mainCategValue != 'select category' && subCtegValue != 'subcategory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imgFileList!.isNotEmpty) {
          setState(() {
            processing = true;
          });
          try {
            for (var image in imgFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('product/${path.basename(image.path)}');
              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imgUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please pick image first');
        }
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please select categories');
    }
  }

  void uploadData() async {
    if (imgUrlList.isNotEmpty) {
      CollectionReference productRef = store.collection('products');
      proId = const Uuid().v4();
      await productRef.doc(proId).set({
        'proid': proId,
        'maincateg': mainCategValue,
        'subcateg': subCtegValue,
        'price': price,
        'instock': quantity,
        'proname': proName,
        'prodesc': proDesc,
        'sid': auth.currentUser!.uid,
        'proimage': imgUrlList,
        'discount': discount,
      }).whenComplete(() {
        setState(() {
          processing = false;
          imgFileList = [];
          mainCategValue = 'select category';
          subCategList = [];
          imgUrlList = [];
        });
      });
      _formKey.currentState!.reset();
    } else {
      print('no images');
    }
  }

  void uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
  }

  void selectedMainCateg(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }
    print(value);
    setState(() {
      mainCategValue = value!;
      subCtegValue = 'subcategory';
    });
  }
}

var textFormDecoration = const InputDecoration(
    labelText: 'price',
    hintText: 'price .. \$',
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrange, width: 2)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrange, width: 2)));

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
