import 'package:business_sqflite/constants/constants.dart';
import 'package:business_sqflite/db/local_db.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductDatabase {
  static Database database = LocalDatabase.database;

  static insertProduct(
      {String productName,
      String productDescription,
      double productPrice}) async {
    final db = database;

    db.insert(Constants.productTable, {
      "product_name": productName,
      "product_description": productDescription,
      "product_price": productPrice
    });
  }

  static List<Map<String, dynamic>> productList = [];

  static getProduct() async {
    final db = database;

    productList = await db.query(Constants.productTable);

    print(productList);
  }

  static updateProduct(int id,
      {String productName,
      String productDescription,
      double productPrice}) async {
    final db = database;

    Map<String, dynamic> data = {
      "product_name": productName,
      "product_description": productDescription,
      "product_price": productPrice
    };

    await db
        .update(Constants.productTable, data, where: 'id = ?', whereArgs: [id]);

    productList = await db.query(Constants.productTable);

    print(productList);
  }

  static deleteProduct(int id) async {
    final db = database;

    await db.delete(Constants.productTable, where: 'id = ?', whereArgs: [id]);

    productList = await db.query(Constants.productTable);

    print(productList);
  }
}
