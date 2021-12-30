import 'package:business_sqflite/common_widgets/custom_textfield.dart';
import 'package:business_sqflite/db/local_db.dart';
import 'package:business_sqflite/db/product_db.dart';
import 'package:business_sqflite/screens/register_screen.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await LocalDatabase.getDatabase();
      await ProductDatabase.getProduct();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Products'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Container()),
            Text(LocalDatabase.userData.name),
            Text(LocalDatabase.userData.about),
            Text(LocalDatabase.userData.location),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: ProductDatabase.productList.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(
                    ProductDatabase.productList[index]['product_name'] ?? ''),
                subtitle: Text(ProductDatabase.productList[index]
                        ['product_description'] ??
                    ''),
                leading: Text(ProductDatabase.productList[index]
                            ['product_price']
                        .toString() ??
                    ''),
                trailing: IntrinsicWidth(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _productNameController.text = ProductDatabase
                              .productList[index]['product_name'];

                          _productDescriptionController.text = ProductDatabase
                              .productList[index]['product_description'];
                          _productPriceController.text = ProductDatabase
                              .productList[index]['product_price']
                              .toString();

                          int id = ProductDatabase.productList[index]['id'];
                          print(id);

                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                      top: 40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Update Product'),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      CustomTextField(
                                        controller: _productNameController,
                                        hintText: 'Prouct name',
                                      ),
                                      const SizedBox(height: 30),
                                      CustomTextField(
                                        controller:
                                            _productDescriptionController,
                                        hintText: 'description',
                                      ),
                                      const SizedBox(height: 30),
                                      CustomTextField(
                                        controller: _productPriceController,
                                        hintText: 'Product price',
                                      ),
                                      const SizedBox(height: 15),
                                      SimpleElevatedButton(
                                        buttonName: 'Update product',
                                        onPressed: () async {
                                          await LocalDatabase.getDatabase();
                                          await ProductDatabase.updateProduct(
                                              id,
                                              productName:
                                                  _productNameController.text,
                                              productDescription:
                                                  _productDescriptionController
                                                      .text,
                                              productPrice: double.parse(
                                                  _productPriceController
                                                      .text));
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Product updated successfully!!'));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);

                                          _productNameController.clear();
                                          _productDescriptionController.clear();
                                          _productPriceController.clear();

                                          await ProductDatabase.getProduct();
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          int id = ProductDatabase.productList[index]['id'];
                          print(id);
                          await LocalDatabase.getDatabase();
                          await ProductDatabase.deleteProduct(id);
                          setState(() {});
                          final snackBar = SnackBar(
                              content: Text('Product deleted successfully!!'));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Add Product'),
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
                              productDescription:
                                  _productDescriptionController.text,
                              productPrice:
                                  double.parse(_productPriceController.text));
                          final snackBar = SnackBar(
                              content: Text('Product added successfully!!'));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          _productNameController.clear();
                          _productDescriptionController.clear();
                          _productPriceController.clear();

                          await ProductDatabase.getProduct();
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),

                      // SimpleElevatedButton(
                      //   buttonName: 'Get product',
                      //   onPressed: () async {
                      //     await LocalDatabase.getDatabase();
                      //     await ProductDatabase.getProduct();
                      //
                      //     // ProductDatabase.getProduct();
                      //   },
                      // ),
                      // SimpleElevatedButton(
                      //   buttonName: 'Update product',
                      //   onPressed: () async {
                      //     await LocalDatabase.getDatabase();
                      //     await ProductDatabase.updateProduct(1,productName: 'water bottle',productPrice: 67, productDescription: 'Yellow water Bottle');
                      //     setState(() {});
                      //
                      //     // ProductDatabase.getProduct();
                      //   },
                      // ),
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
