import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../servixe/globas_service.dart';
import '../widgets/widget_button.dart';

const textColor = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.deepOrange,
  Colors.teal,
];

class WelcomPage extends StatefulWidget {
  const WelcomPage({Key? key}) : super(key: key);

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool processing = false;
  CollectionReference customers = store.collection('customers');
  CollectionReference anonymous = store.collection('anonymous');

  late String _uid;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<bool> checkIfDocExists(String docId) async {
  //   try {
  //     var doc = await customers.doc(docId).get();
  //     return doc.exists;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // bool docExists = false;

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   return await auth.signInWithCredential(credential).whenComplete(() async {
  //     User user = auth.currentUser!;
  //     print(googleUser!.id);
  //     print(auth.currentUser!.uid);
  //     print(googleUser);
  //     print(user);

  //     docExists = await checkIfDocExists(user.uid);
  //     docExists == false
  //         ? await customers.doc(user.uid).set({
  //             'name': googleUser.displayName,
  //             'email': googleUser.email,
  //             'profileImage': googleUser.photoUrl,
  //             'phone': '',
  //             'address': '',
  //             'cid': user.uid,
  //           }).then((value) => navigate())
  //         : navigate();
  //   });
  // }

  // navigate() {
  //   Navigator.pushReplacementNamed(context, 'onboarding_page');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/inapp/bgimage.jpg'),
                fit: BoxFit.cover)),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('WELCOME',
                      textStyle: GoogleFonts.acme(
                          fontSize: 45, fontWeight: FontWeight.bold),
                      colors: textColor),
                  ColorizeAnimatedText('Shophup Store',
                      textStyle: GoogleFonts.acme(
                          fontSize: 45, fontWeight: FontWeight.bold),
                      colors: textColor)
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              const SizedBox(
                height: 120,
                width: 200,
                child: Image(image: AssetImage('images/inapp/shophub.png')),
              ),
              SizedBox(
                height: 80,
                child: DefaultTextStyle(
                  style: GoogleFonts.acme(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreenAccent,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Buy'),
                      RotateAnimatedText('Shop'),
                      RotateAnimatedText('Shophub Store')
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Suppliers only',
                            style: GoogleFonts.acme(
                                letterSpacing: 1.8,
                                color: Colors.yellowAccent,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AnimationLogo(controller: _controller),
                                AuthButton(
                                  width: 0.25,
                                  name: 'Log In',
                                  press: () {
                                    Navigator.pushReplacementNamed(
                                        context, 'supplier_login');
                                  },
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: AuthButton(
                                    width: 0.25,
                                    name: 'Sign Up',
                                    press: () {
                                      Navigator.pushReplacementNamed(
                                          context, 'supplier_signup');
                                    },
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AuthButton(
                                width: 0.25,
                                name: 'Log In',
                                press: () {
                                  Navigator.pushReplacementNamed(
                                      context, 'customer_login');
                                },
                                color: Colors.white,
                              ),
                            ),
                            AuthButton(
                              width: 0.25,
                              name: 'Sign Up',
                              press: () {
                                Navigator.pushReplacementNamed(
                                    context, 'customer_signup');
                              },
                              color: Colors.white,
                            ),
                            AnimationLogo(controller: _controller),
                          ],
                        )),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GoogleFacebookLogin(
                        label: 'Google',
                        child: const Image(
                            image: AssetImage('images/inapp/google.jpg')),
                        press: () {},
                      ),
                      GoogleFacebookLogin(
                        label: 'Facebook',
                        child: const Image(
                            image: AssetImage('images/inapp/facebook.jpg')),
                        press: () {},
                      ),
                      processing == true
                          ? const CircularProgressIndicator()
                          : GoogleFacebookLogin(
                              label: 'Guest',
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.lightBlueAccent,
                              ),
                              press: () async {
                                setState(() {
                                  processing = true;
                                });

                                await auth
                                    .signInAnonymously()
                                    .whenComplete(() async {
                                  _uid = auth.currentUser!.uid;
                                  await anonymous.doc(_uid).set({
                                    'name': '',
                                    'email': '',
                                    'profileImage': '',
                                    'phone': '',
                                    'address': '',
                                    'cid': _uid,
                                  });
                                });
                                await Future.delayed(
                                        const Duration(microseconds: 100))
                                    .whenComplete(() =>
                                        Navigator.pushReplacementNamed(
                                            context, 'customer_home'));
                              },
                            )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimationLogo extends StatelessWidget {
  const AnimationLogo({
    Key? key,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(image: AssetImage('images/inapp/shophub.png')),
    );
  }
}

class GoogleFacebookLogin extends StatelessWidget {
  final String label;
  final Function()? press;
  final Widget? child;
  const GoogleFacebookLogin({
    Key? key,
    required this.label,
    this.press,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: press,
        child: Column(
          children: [
            SizedBox(width: 35, height: 35, child: child),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
