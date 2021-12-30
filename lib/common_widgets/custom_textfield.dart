import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  TextAlign textAlign;
  Widget suffixIcon;
  Color fillColor;
  Color borderColor;
  TextStyle hintStyle;
  int maxLine;
  Function(String) validator;
  Function(String) onChange;
  TextInputType keyboardType;
  bool obscureText;
  bool readOnly;
  List<TextInputFormatter> inputFormatter;

  CustomTextField({
    Key key,
    this.controller,
    this.hintText,
    this.textAlign,
    this.fillColor,
    this.borderColor,
    this.hintStyle,
    this.maxLine,
    this.onChange,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.readOnly,
    this.inputFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatter,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      maxLines: maxLine ?? 1,
      textAlign: textAlign ?? TextAlign.center,
      controller: controller,
      readOnly: readOnly ?? false,
      onChanged: onChange,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.grey)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(5)),
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(fontSize: 12, color: Colors.grey),
      ),
      validator: validator,
    );
  }
}
