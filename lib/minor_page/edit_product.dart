import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/servixe/globas_service.dart';
import 'package:hub/widgets/alert_dialog.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../utilities/categ_list.dart';
import '../widgets/snackbar.dart';
import 'package:path/path.dart' as path;

class EditProduct extends StatefulWidget {
  final dynamic items;
  const EditProduct({super.key, this.items});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
  List<dynamic> imgUrlList = [];

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

  Widget previewCurrentImages() {
    List<dynamic> itemImg = widget.items['proimage'];
    return ListView.builder(
        itemCount: itemImg.length,
        itemBuilder: (context, index) {
          return Image.network(
            itemImg[index].toString(),
            fit: BoxFit.cover,
          );
        });
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
                  Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                  color: Colors.blueGrey.shade100,
                                  height: size.width * 0.5,
                                  width: size.width * 0.5,
                                  child: previewCurrentImages()),
                              imgFileList!.isEmpty
                                  ? const SizedBox()
                                  : Positioned(
                                      top: 10,
                                      left: 10,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Colors.blueGrey.shade100,
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
                                  'main category',
                                  style: GoogleFonts.acme(
                                      color: Colors.teal, fontSize: 18),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 3),
                                  margin: const EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                      maxWidth: size.width * 0.35),
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.items['maincateg'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'subcategory',
                                  style: GoogleFonts.acme(
                                      color: Colors.teal, fontSize: 18),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 3),
                                  margin: const EdgeInsets.all(6),
                                  constraints: BoxConstraints(
                                      maxWidth: size.width * 0.35),
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.items['subcateg'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      ExpandablePanel(
                        theme: const ExpandableThemeData(hasIcon: false),
                        header: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'edit product',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.teal,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                decorationColor: Colors.teal,
                                decorationStyle: TextDecorationStyle.dotted,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        collapsed: const SizedBox(
                          height: 0,
                          child: SizedBox(),
                        ),
                        expanded: changeImage(size),
                      ),
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
                              initialValue:
                                  widget.items['price'].toStringAsFixed(2),
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
                            initialValue: widget.items['discount'].toString(),
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
                          initialValue: widget.items['instock'].toString(),
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
                          initialValue: widget.items['proname'],
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
                          initialValue: widget.items['prodesc'],
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TealButton(
                            height: 35,
                            width: 0.25,
                            name: 'Cacel',
                            txtColor: Colors.white,
                            color: Colors.teal,
                            press: () {
                              Navigator.pop(context);
                            },
                          ),
                          TealButton(
                            height: 35,
                            width: 0.35,
                            color: Colors.teal,
                            name: 'Save Changes',
                            txtColor: Colors.white,
                            press: () {
                              saveChanges();
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: TealButton(
                          width: 0.81,
                          name: 'Delete',
                          txtColor: Colors.white,
                          press: () {
                            MyAlertDialog.showMyDialog(
                              contant: 'Are you sure to delet this product ?',
                              context: context,
                              tabNo: () {
                                Navigator.pop(context);
                              },
                              tabYes: () async {
                                await store.runTransaction((transaction) async {
                                  DocumentReference dRf = store
                                      .collection('products')
                                      .doc(widget.items['proid']);
                                  transaction.delete(dRf);
                                }).whenComplete(() => Navigator.popUntil(
                                    context,
                                    ModalRoute.withName('supplier_home')));
                              },
                              title: 'Delete',
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changeImage(Size size) {
    return Column(
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
                    style: GoogleFonts.acme(color: Colors.teal, fontSize: 18),
                  ),
                  DropdownButton(
                      icon: const Icon(Icons.expand_more),
                      value: mainCategValue,
                      items: maincateg.map<DropdownMenuItem<String>>((value) {
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
                    style: GoogleFonts.acme(color: Colors.teal, fontSize: 18),
                  ),
                  DropdownButton(
                      menuMaxHeight: 500,
                      icon: const Icon(Icons.expand_more),
                      disabledHint: const Text(
                        'select category',
                        style: TextStyle(color: Colors.grey),
                      ),
                      value: subCtegValue,
                      items:
                          subCategList.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          subCtegValue = value!;
                        });
                      }),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: imgFileList!.isNotEmpty
              ? TealButton(
                  height: 35,
                  width: 0.35,
                  txtColor: Colors.white,
                  name: 'Reset Images',
                  press: () {
                    setState(() {
                      imgFileList = [];
                    });
                  },
                )
              : TealButton(
                  height: 35,
                  width: 0.35,
                  txtColor: Colors.white,
                  name: 'Save Images',
                  press: () {
                    pickProductImages();
                  },
                ),
        )
      ],
    );
  }

  saveChanges() async {
    await uplaadImages().whenComplete(() => editProductData());
  }

  Future uplaadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imgFileList!.isNotEmpty) {
        if (mainCategValue != 'select category' &&
            subCtegValue != 'subcategory') {
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
            (e);
          }
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please select categories');
        }
      } else {
        imgUrlList = widget.items['proimage'];
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference dRf = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['proid']);
      transaction.update(dRf, {
        'maincateg': mainCategValue,
        'subcateg': subCtegValue,
        'price': price,
        'instock': quantity,
        'proname': proName,
        'prodesc': proDesc,
        'proimage': imgUrlList,
        'discount': discount,
      });
    }).whenComplete(() => Navigator.pop(context));
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
