import 'package:business_sqflite/common_widgets/custom_textfield.dart';
import 'package:business_sqflite/db/local_db.dart';
import 'package:business_sqflite/screens/home_screen.dart';
import 'package:business_sqflite/screens/products_screen.dart';
import 'package:business_sqflite/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                inputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                ],
                validator: (value) {
                  Pattern pattern =
                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';

                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Enter Valid Email';
                  }
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                obscureText: true,
                controller: _passwordController,
                hintText: '* * * * * * *',
                validator: (value) {
                  if (value.length < 3) {
                    return 'Password must be more than 3 Character!';
                  }
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 15),
              SimpleElevatedButton(
                buttonName: 'LOGIN',
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await LocalDatabase.getDatabase();
                    await LocalDatabase.userLogin(
                        email: _emailController.text,
                        password: _passwordController.text);

                    if (LocalDatabase.indexOfEmail != -1) {
                      if (LocalDatabase.indexOfEmailPassword != -1) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsScreen()));

                        _emailController.clear();
                        _passwordController.clear();
                      } else {
                        final snackBar =
                            SnackBar(content: Text('Invalid Password!!'));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      final snackBar = SnackBar(
                        content: Text('You are not registered!!'),
                        action: SnackBarAction(
                          label: 'Registere here',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                  child: Text('Register here'))
            ],
          ),
        ),
      ),
    );
  }
}
