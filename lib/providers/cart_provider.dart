import 'package:flutter/foundation.dart';
import 'package:hub/providers/product_class.dart';
import 'package:hub/providers/sql_helper.dart';

class Cart extends ChangeNotifier {
  static List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(Product product) {
    SQHelper.insertItem(product).whenComplete(() => _list.add(product));
    notifyListeners();
  }

  loadCartItemProvider() async {
    List<Map> data = await SQHelper.loadItems();
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

  void increment(Product product) async {
    await SQHelper.updateItem(product, 'increment')
        .whenComplete(() => product.increase());
    notifyListeners();
  }

  void reduceByOne(Product product) async {
    await SQHelper.updateItem(product, 'reduce')
        .whenComplete(() => product.decrease());

    // product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) async {
    await SQHelper.deleteItem(product.documentId)
        .whenComplete(() => _list.remove(product));

    notifyListeners();
  }

  void clearCart() async {
    await SQHelper.daleteAllItem().whenComplete(() => _list.clear());
    notifyListeners();
  }

  void removeThis(String id) async {
    await SQHelper.deleteItem(id).whenComplete(
        () => _list.removeWhere((element) => element.documentId == id));
    notifyListeners();
  }
}
