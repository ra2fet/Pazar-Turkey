import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';

class TChip extends StatelessWidget {
  final String txt;
  final Function press;
  final Color btnColor;
  final double width;
  final  icon;

  TChip(
      {Key key,
      @required this.txt,
      @required this.press,
      this.btnColor = btnBlue,
      this.width,@required this.icon})
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
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            primary: btnColor,
          ),
          onPressed: press,
          child: Column(
            children: [
             
              icon.toString().startsWith("r")? Icon(Requests.getIcons(icon)):SvgPicture.network(icon,width: 24,),
              Text(txt,textAlign: TextAlign.center,  maxLines: 1,  softWrap: false,  overflow: TextOverflow.fade,),
            ],
          )),
    );
  }
}
