import 'package:flutter/material.dart';
import 'package:pazar_app/utils/app_colors.dart';

class RChip extends StatelessWidget {
  final String txt;
  final Function press;
  final Color btnColor;
  final double width;

  RChip(
      {Key key,
      @required this.txt,
      @required this.press,
      this.btnColor = btnBlue,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            primary: btnColor,
          ),
          onPressed: press,
          child: Text(txt,textAlign: TextAlign.center,)),
    );
  }
}
