// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/minor_page/hot_deals.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/servixe/globas_service.dart';
import 'package:provider/provider.dart';

import '../gallery/shoes_gallery.dart';
import '../minor_page/sub_categ_product.dart';

enum Offer { watches, shoes, sale }

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  Timer? countDowntimer;
  int seconds = 15;
  List<int> discountList = [];
  int? maxDiscount;
  late int selectedIndex;
  late String offerName;
  late String assetName;
  late Offer offer;
  late AnimationController animationController;
  late Animation<Color?> colorTweenAnimation;
  String? name;
  String suppId = '';

  @override
  void initState() {
    selectRandomOffer();
    startTimer();

    getDiscount();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    colorTweenAnimation = ColorTween(begin: Colors.teal, end: Colors.red)
        .animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationController.repeat();
    context.read<IdProvider>().getDocId();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void navigateToOffer() {
    switch (offer) {
      case Offer.watches:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const SubCategProducts(
                      subcategName: 'sart watch',
                      maincategName: 'electronics',
                      fromOnBoarding: true,
                    )),
            (Route route) => false);
        break;
      case Offer.shoes:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const ShoesGallery(
                      fromOnBoarding: true,
                    )),
            (Route route) => false);
        break;
      case Offer.sale:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HotDealsPage(
                      fromOnBoarding: true,
                      maxDiscount: maxDiscount!.toString(),
                    )),
            (Route route) => false);
        break;
    }
  }

  void selectRandomOffer() {
    for (var i = 0; i < Offer.values.length; i++) {
      var random = Random();
      setState(() {
        selectedIndex = random.nextInt(3);
        offerName = Offer.values[selectedIndex].toString();
        assetName = offerName.replaceAll('Offer.', '');
        offer = Offer.values[selectedIndex];
      });
      print(selectedIndex);
      print(offerName);
      print(assetName);
    }
  }

  void getDiscount() {
    store.collection('products').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        discountList.add(doc['discount']);
      }
    }).whenComplete(() => setState(() {
          maxDiscount = discountList.reduce(max);
        }));
  }

  void startTimer() {
    countDowntimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds < 0) {
        stopTimer();
        Navigator.pushReplacementNamed(context, 'customer_home');
      }
      (timer.tick);
      (seconds);
    });
  }

  void stopTimer() {
    countDowntimer!.cancel();
  }

  Widget buildAsset() {
    return Image.asset(
      'images/onboard/$assetName.JPEG',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
              onTap: () {
                stopTimer();
                navigateToOffer();
              },
              child: buildAsset()),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              height: 35,
              width: 90,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(30)),
              child: MaterialButton(
                onPressed: () {
                  stopTimer();
                  Navigator.pushReplacementNamed(context, 'customer_home');
                },
                child: seconds < 1
                    ? const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        'Skip |  $seconds',
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ),
          offer == Offer.sale
              ? Positioned(
                  top: 190,
                  right: 80,
                  child: AnimatedOpacity(
                    duration: const Duration(microseconds: 100),
                    opacity: animationController.value,
                    child: Text(
                      '$maxDiscount %',
                      style: GoogleFonts.acme(
                        fontSize: 100,
                        color: Colors.amber,
                      ),
                    ),
                  ))
              : const SizedBox(),
          Positioned(
            bottom: 70,
            child: AnimatedBuilder(
                animation: animationController.view,
                builder: (context, child) {
                  return Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      color: colorTweenAnimation.value,
                      child: child);
                },
                child: Center(
                  child: Text(
                    'SHOP NOW',
                    style: GoogleFonts.actor(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
