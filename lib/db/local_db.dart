import 'package:business_sqflite/constants/constants.dart';
import 'package:business_sqflite/models/profiledata_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static ProfileData profileData;

  static int indexOfEmail;

  static int indexOfEmailPassword;

  static Database database;

  static getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, Constants.dbName);
    print('success');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      print('success');

      await db.execute(
          'CREATE TABLE ${Constants.userTable} (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, email TEXT, password TEXT)');
      await db.execute(
          'CREATE TABLE ${Constants.productTable} (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, product_name TEXT, product_description TEXT, product_price REAL)');
    });
  }

//  static closeDatabase(){
//
//    final db = database;
// db.close();
//  }
  static checkUserRegisteredOrNot(String email) async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query(Constants.userTable);

    indexOfEmail = maps.indexWhere((element) => element['email'] == email);

    print(indexOfEmail);
  }

  static registerUser({String name, String email, String password}) async {
    final db = database;

    await checkUserRegisteredOrNot(email);

    if (indexOfEmail == -1) {
      db.insert(Constants.userTable,
          {"name": name, "email": email, "password": password});
    }
  }

  static userLogin({String email, String password}) async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query(Constants.userTable);

    indexOfEmail = maps.indexWhere((element) => element['email'] == email);

    print(indexOfEmail);
    if (indexOfEmail != -1) {
      indexOfEmailPassword = maps.indexWhere((element) =>
          element['email'] == email && element['password'] == password);

      print(indexOfEmailPassword);

      if (indexOfEmailPassword != -1) {
        profileData = ProfileData(
            email: maps[indexOfEmailPassword]["email"],
            id: maps[indexOfEmailPassword]["id"],
            name: maps[indexOfEmailPassword]["name"],
            password: maps[indexOfEmailPassword]["password"]);
      }
    } else {
      print('Failed');
    }
  }
}
