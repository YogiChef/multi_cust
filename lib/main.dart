// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hub/main_page/onboarding.dart';
import 'package:hub/main_page/welcom.dart';
import 'package:hub/minor_page/search.dart';
import 'package:hub/providers/cart_provider.dart';
import 'package:hub/providers/id_provider.dart';
import 'package:hub/providers/sql_helper.dart';
import 'package:hub/providers/wish_provider.dart';
import 'package:hub/service/global_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hub/service/notification_service.dart';
import 'package:provider/provider.dart';
import 'auth/customer_login.dart';
import 'auth/customer_signup.dart';
import 'main_page/customer_home_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Customers App //Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
  print("Handling a background message: ${message.notification!.body}");
  print("Handling a background message: ${message.data}");
  print("Customers App //Handling a background message: ${message.data['key1']}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  
  NotificationService.createNotificationChannelAndIntailize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Stripe.publishableKey = stripePublishbleKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  SQHelper.getDatabase;

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
    ChangeNotifierProvider(create: (_) => IdProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent,));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'onboarding_page',
      routes: {
        'welcome_page': (context) => const WelcomPage(),
        'onboarding_page': (context) => const OnboardingPage(),
        'customer_home': (context) => const CustomerHomePage(),
        'customer_signup': (context) => const CustomerRegister(),
        'customer_login': (context) => const CustomerLogin(),
        'search': (context) => const SearchPage(),
      },
    );
  }
}
