import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialItem extends StatelessWidget {
  final img;
  final Function press;

  SocialItem({
    Key key,
    @required this.img,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
          width: size.width * 0.15,
          child: SvgPicture.asset(
            "assets/icons/$img.svg",
            semanticsLabel: "whatsapp",
          )),
      onTap: press,
    );
  }
}
