import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/service/global_service.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:hub/widgets/auth_widget.dart';
import 'package:hub/widgets/snackbar.dart';
import 'package:hub/widgets/widget_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({
    super.key,
  });

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late String firstname;
  late String lastname;
  late String phone;
  late String zipcode;
  String countryValue = 'Country';
  String stateValue = 'State';
  String cityValue = 'City';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: const AppBarBackButton(),
          title: const AppbarTitle(
            title: 'Add New Address',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 60),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: InputTextforfield(
                            label: 'first Name',
                            hint: 'Enter your first nmae',
                            keyboardType: TextInputType.name,
                            onSaved: (value) {
                              firstname = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: InputTextforfield(
                            label: 'last Name',
                            hint: 'Enter your last name',
                            onSaved: (value) {
                              lastname = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: InputTextforfield(
                            label: 'phone ',
                            hint: 'Enter your phone ',
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            onSaved: (value) {
                              phone = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone ';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        SelectState(
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },
                          onStateChanged: (value) {
                            stateValue = value;
                          },
                          onCityChanged: (value) {
                            cityValue = value;
                          },
                          style: const TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: InputTextforfield(
                            label: 'Zip Code',
                            hint: 'Enter your zip code',
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            onSaved: (value) {
                              zipcode = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your zip code';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TealButton(
            width: 0.8,
            name: 'Save New Address',
            txtColor: Colors.white,
            fontSize: 12,
            press: () async {
              if (formKey.currentState!.validate()) {
                if (countryValue != 'Choose Country' &&
                    stateValue != 'Choose State' &&
                    cityValue != 'Choose City') {
                  formKey.currentState!.save();
                  CollectionReference addressRef = store
                      .collection('customers')
                      .doc(
                        /*auth.currentUser!.uid*/ context
                            .read<IdProvider>()
                            .getData,
                      )
                      .collection('address');
                  var addressId = const Uuid().v4();
                  await addressRef.doc(addressId).set({
                    'addressid': addressId,
                    'firstname': firstname,
                    'lastname': lastname,
                    'phone': phone,
                    'country': countryValue,
                    'state': stateValue,
                    'city': cityValue,
                    'zipcode': zipcode,
                    'default': true,
                  }).whenComplete(() => Navigator.pop(context));
                } else {
                  MyMessageHandler.showSnackBar(
                      scaffoldKey, 'pleas set your location');
                }
              } else {
                MyMessageHandler.showSnackBar(
                    scaffoldKey, 'pleas fill all fields');
              }
            },
          ),
        ),
      ),
    );
  }
}
