import 'package:business_sqflite/common_widgets/custom_textfield.dart';
import 'package:business_sqflite/db/local_db.dart';
import 'package:business_sqflite/db/product_db.dart';
import 'package:business_sqflite/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              CustomTextField(
                controller: _productNameController,
                hintText: 'Prouct name',
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _productDescriptionController,
                hintText: 'description',
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _productPriceController,
                hintText: 'Product price',
              ),
              const SizedBox(height: 15),
              SimpleElevatedButton(
                buttonName: 'Add product',
                onPressed: () async {
                  await LocalDatabase.getDatabase();
                  await ProductDatabase.insertProduct(
                      productName: _productNameController.text,
                      productDescription: _productDescriptionController.text,
                      productPrice: double.parse(_productPriceController.text));
                  final snackBar =
                      SnackBar(content: Text('Product added successfully!!'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  _productNameController.clear();
                  _productDescriptionController.clear();
                  _productPriceController.clear();

                  await ProductDatabase.getProduct();
                  setState(() {});
                },
              ),
              SimpleElevatedButton(
                buttonName: 'Get product',
                onPressed: () async {
                  await LocalDatabase.getDatabase();
                  await ProductDatabase.getProduct();

                  // ProductDatabase.getProduct();
                },
              ),
              SimpleElevatedButton(
                buttonName: 'Update product',
                onPressed: () async {
                  await LocalDatabase.getDatabase();
                  await ProductDatabase.updateProduct(1,
                      productName: 'water bottle',
                      productPrice: 67,
                      productDescription: 'Yellow water Bottle');
                  setState(() {});

                  // ProductDatabase.getProduct();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
