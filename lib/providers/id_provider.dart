// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> documentId;
  late String docId;

  static String _custId = '';
  String get getData {
    return _custId;
  }

  setCustId(User user) async {
    final SharedPreferences pref = await _prefs;
    pref.setString('custId', user.uid).whenComplete(
          () => _custId = user.uid,
        );
    print('customerid was saved into shared preferences');
    notifyListeners();
  }

  clearCustId() async {
    final SharedPreferences pref = await _prefs;
    pref.setString('custId', '').whenComplete(
          () => _custId = '',
        );
    print('customerid was removed from shared preferences');

    notifyListeners();
  }

  Future<String> getDocumentId() {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString('custId') ?? '';
    });
  }

  getDocId() async {
    await getDocumentId().then(
      (value) => _custId = value,
    );
    print('customerid was updated into provider');
    notifyListeners();
  }
}
