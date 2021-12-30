import 'package:business_sqflite/common_widgets/custom_textfield.dart';
import 'package:business_sqflite/db/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value.isEmpty) {
                      return ' Enter Your Name';
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 40),
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
                const SizedBox(height: 40),
                CustomTextField(
                  obscureText: true,
                  controller: _passwordController,
                  hintText: 'Password',
                  validator: (value) {
                    if (value.length < 6) {
                      return 'Password must be More than 6 character';
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 40),
                SimpleElevatedButton(
                  buttonName: 'REGISTER',
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await LocalDatabase.getDatabase();
                      await LocalDatabase.checkUserRegisteredOrNot(
                          _emailController.text);

                      if (LocalDatabase.indexOfEmail == -1) {
                        await LocalDatabase.registerUser(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text);

                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();

                        final snackBar =
                            SnackBar(content: Text('Registered successfully!'));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        print('Email already register');

                        final snackBar = SnackBar(
                            content: Text('Email Already registered.'));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleElevatedButton extends StatelessWidget {
  VoidCallback onPressed;
  String buttonName;
  Color color;
  TextStyle style;
  SimpleElevatedButton(
      {Key key, this.onPressed, this.buttonName, this.color, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonName,
            textAlign: TextAlign.center,
            style: style ?? TextStyle(fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(114, 20),
          padding: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
          primary: color ?? Colors.blue,
        ));
  }
}
