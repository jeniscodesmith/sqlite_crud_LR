import 'package:business_sqflite/screens/home_screen.dart';
import 'package:business_sqflite/screens/login_screen.dart';
import 'package:business_sqflite/screens/products_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
