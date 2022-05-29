import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class Tablemodel {
  static final List<String> values = [
    productid,
    productName,
    productUrl,
    productRating,
    productDiscription,
  ];
  static const String productid = 'productId';
  static const String productName = 'productName';
  static const String productUrl = 'productUrl';
  static const String productRating = 'productRating';
  static const String productDiscription = 'productDiscription';
}

class ProductsDatabase {
  static final ProductsDatabase instance = ProductsDatabase._init();

  static Database? _database;

  ProductsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('productsdatabasenew.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$filePath';

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE ProductsTable ( 
  ${Tablemodel.productid} INTEGER not null,
  ${Tablemodel.productName} TEXT NOT NULL,
  ${Tablemodel.productUrl} TEXT NOT NULL,
  ${Tablemodel.productRating} TEXT NOT NULL,
  ${Tablemodel.productDiscription} TEXT NOT NULL,
  PRIMARY KEY  (`productId`)
  )
''');
  }

  Future<void> insertallproducts() async {
    final db = await database;
    final String response =
        await rootBundle.loadString('assets/productsjson.json');
    final data = await jsonDecode(response) as List<dynamic>;
    for (var i in data) {
      final id = await db.rawInsert(
          'INSERT OR IGNORE INTO ProductsTable(${Tablemodel.productid},${Tablemodel.productName}, ${Tablemodel.productUrl},${Tablemodel.productRating}, ${Tablemodel.productDiscription}) VALUES("${i['productid']}","${i['productname']}", "${i['producturl']}","${i['productrating']}","${i['productdiscription']}")');
      if (id == 0) {
        return;
      }
    }
  }
}
