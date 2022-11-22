import 'package:flutter/foundation.dart';
import 'package:hub/providers/product_class.dart';
import 'package:hub/providers/sql_helper.dart';

class Wish extends ChangeNotifier {
  static List<Product> _list = [];
  List<Product> get getWishItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addWishItem(Product product) async {
    SQHelper.insertWishlist(product).whenComplete(() => _list.add(product));
    notifyListeners();
  }

  loadWishlistProvider() async {
    List<Map> data = await SQHelper.loadWishlist();
    _list = data.map((product) {
      return Product(
        documentId: product['documentId'],
        name: product['name'],
        price: product['price'],
        qty: product['qty'],
        qntty: product['qntty'],
        imagesUrl: product['imagesUrl'],
        suppId: product['suppId'],
      );
    }).toList();
    notifyListeners();
  }

  void removeItem(Product product) async {
    await SQHelper.deleteWishlist(product.documentId)
        .whenComplete(() => _list.remove(product));
    notifyListeners();
  }

  void clearWishList() async {
    await SQHelper.daleteAllWishlist().whenComplete(() => _list.clear());
    notifyListeners();
  }

  void removeThis(String id) async {
    await SQHelper.deleteWishlist(id).whenComplete(
        () => _list.removeWhere((element) => element.documentId == id));
    notifyListeners();
  }
}
