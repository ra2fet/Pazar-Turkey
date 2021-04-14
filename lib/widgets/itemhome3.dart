import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemHome3 extends StatelessWidget {

final String title;
final String img;
final Function press;

final width ;
final double height;

  const ItemHome3({Key key, this.width, this.height ,@required this.title,@required this.img, @required this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
      child: Container(
        height: height,
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: size.width * width,
              child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                elevation: 3,
                color: Colors.white,   
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title),
                    SizedBox(height: size.height* 0.01,),
                    Container( child: SvgPicture.asset("assets/images/$img.svg",semanticsLabel: "realstate",height:size.height*0.15)),
                                      SizedBox(height: size.height* 0.03,),

                    
                  ],
                ),
              ),
              
            ),
    );
  }
}