import 'package:flutter/foundation.dart';
import '../model/productmodel.dart';
import '../database/database.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _productslist = [];

  List<Product> get productslist {
    return _productslist;
  }

  Future<bool> loadproducts({required int lastproductid}) async {
    if (lastproductid == 1) {
      _productslist.clear();
    }
    final db = await ProductsDatabase.instance.database;
    final result = await db.rawQuery(
        "SELECT * FROM ProductsTable WHERE productId >= $lastproductid ORDER BY productId ASC LIMIT 100");

    if (result.isEmpty) {
      return false;
    } else {
      for (var element in result) {
        _productslist.add(Product.fromJson(element));
      }
      notifyListeners();
      return true;
    }
  }
}
