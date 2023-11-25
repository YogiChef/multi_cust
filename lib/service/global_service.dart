import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore store = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;
Stripe stripe = Stripe.instance;

const stripePublishbleKey =
    'pk_test_51LmBqlDt5IkBFjIiFKXxvBY6ZGMJAsCWXxxdb6l95m78mfRZmyOi4ZxBacCRC1zBAp7YhpxJNdiWunh8V4kltpAf000pfeb3Z3';
const stripeSecretKey =
    'sk_test_51LmBqlDt5IkBFjIidWnmSBnlex7Qz4NDwLOtNvNuL0s6wC20DMDKBpaSoYC1FkQZXMQfaH6dvXSqTDmaIxDSbZDC00Ru840KVd';
