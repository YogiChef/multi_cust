import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/providers/auth_repo.dart';
import 'package:hub/service/globas_service.dart';
import 'package:hub/widgets/appbar_widgets.dart';
import 'package:hub/widgets/auth_widget.dart';
import 'package:hub/widgets/snackbar.dart';

class ChangeNewPassword extends StatefulWidget {
  const ChangeNewPassword({super.key});

  @override
  State<ChangeNewPassword> createState() => _ChangeNewPasswordState();
}

class _ChangeNewPasswordState extends State<ChangeNewPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController newPass = TextEditingController();
  final TextEditingController oldPass = TextEditingController();

  bool checkPassword = true;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
          appBar: AppBar(
            leading: const AppBarBackButton(),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: const AppbarTitle(title: 'Change Password ?'),
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
                          'to change your new password',
                          style: GoogleFonts.acme(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextforfield(
                          controller: oldPass,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your current password ';
                            }
                            return null;
                          },
                          errorText: checkPassword != true
                              ? 'not valid password'
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          label: 'current password',
                          hint: 'enter your current password'),
                      InputTextforfield(
                          controller: newPass,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your new password ';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          label: 'new password',
                          hint: 'enter your new password'),
                      InputTextforfield(
                          validator: (value) {
                            if (value != newPass.text.trim()) {
                              return 'password not maching ';
                            } else if (value!.isEmpty) {
                              return 'Re-enter your new password';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          label: 'confirm password',
                          hint: 'confirm your new password'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FlutterPwValidator(
                            width: 400,
                            height: 120,
                            minLength: 8,
                            uppercaseCharCount: 1,
                            numericCharCount: 2,
                            specialCharCount: 1,
                            onSuccess: () {},
                            onFail: () {},
                            controller: newPass),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      processing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.purpleAccent,
                            ))
                          : MaterialButton(
                              color: Colors.teal,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  checkPassword =
                                      await AuthRepo.checkOldPassword(
                                          auth.currentUser!.email!,
                                          oldPass.text);
                                  setState(() {
                                    checkPassword == true;
                                    processing = true;
                                  });
                                  checkPassword == true
                                      ? await AuthRepo.updateUserPassword(
                                              newPass.text.trim())
                                          .whenComplete(() {
                                          _formKey.currentState!.reset();
                                          newPass.clear();
                                          MyMessageHandler.showSnackBar(
                                              scaffoldKey,
                                              'your password has been updated');
                                        }).whenComplete(
                                              () => Navigator.pop(context))
                                      : ('not valid old password');
                                  ('form valid');
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
                                'Save Changes',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                    ],
                  )),
            ),
          )),
    );
  }
}
