import 'package:flutter/material.dart';

class RTextBox extends StatelessWidget {
  const RTextBox(
      {Key key,
      @required this.controller,
      @required this.ispass,
      this.width = 0.8,
      this.type = TextInputType.text,
      @required this.hinttxt})
      : super(key: key);

  final TextEditingController controller;
  final ispass;
  final width;
  final String hinttxt;
  final type;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Material(
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(25),
      elevation: 3,
      child: Container(
        width: size * width,
        child: TextField(
          controller: controller,
          obscureText: ispass,
          keyboardType: type,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            hintText: hinttxt,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }
}
